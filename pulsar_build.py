#!/usr/bin/env python3
# Shared data builder: reads a get-pods JSON, geolocates node IPs (cached), writes the JS data file.
# Usage: pulsar_build.py <input_pods.json> <output.js> <VARPREFIX>   (VARPREFIX = NETWORK or NETWORK_MAINNET)
import sys, json, time, os, urllib.request

inp, outp, prefix = sys.argv[1], sys.argv[2], sys.argv[3]
data = json.load(open(inp))
pods = data.get("result", {}).get("pods", [])

CACHE = "/root/geo_cache.json"
try:
    cache = json.load(open(CACHE))
except Exception:
    cache = {}

def ip_of(addr):
    return (addr or "").split(":")[0]

need = sorted({ip_of(p.get("address")) for p in pods if ip_of(p.get("address")) and ip_of(p.get("address")) not in cache})

for i in range(0, len(need), 100):
    chunk = need[i:i+100]
    body = json.dumps([{"query": ip, "fields": "status,countryCode,city,lat,lon,query"} for ip in chunk]).encode()
    try:
        req = urllib.request.Request("http://ip-api.com/batch", data=body, headers={"Content-Type": "application/json"})
        for r in json.load(urllib.request.urlopen(req, timeout=20)):
            if r.get("status") == "success":
                cache[r["query"]] = {"cc": r.get("countryCode"), "city": r.get("city"), "lat": r.get("lat"), "lon": r.get("lon")}
            else:
                cache[r.get("query", "")] = {}
        time.sleep(1)
    except Exception as e:
        sys.stderr.write("geo err: %s\n" % e)

json.dump(cache, open(CACHE, "w"))

for p in pods:
    g = cache.get(ip_of(p.get("address"))) or {}
    if g.get("lat") is not None:
        p["cc"], p["city"], p["lat"], p["lon"] = g.get("cc"), g.get("city"), g.get("lat"), g.get("lon")

ts = int(time.time())
upd = time.strftime("%Y-%m-%d %H:%M", time.gmtime(ts)) + " UTC"
with open(outp, "w") as f:
    f.write("// auto-generated %s\n" % upd)
    f.write("window.%s_UPDATED = %s;\n" % (prefix, json.dumps(upd)))
    f.write("window.%s_GENERATED_TS = %d;\n" % (prefix, ts))
    f.write("window.%s = %s;\n" % (prefix, json.dumps(data, separators=(",", ":"))))
print("wrote %s (%d pods, %d geocoded)" % (outp, len(pods), sum(1 for p in pods if p.get("lat") is not None)))
