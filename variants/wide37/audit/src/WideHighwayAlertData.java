package com.navipilot.obf;
final class WideHighwayAlertData {
static final WideHcopRoad.Camera[] CAMERAS = {
make("36d864c7458c5701","321812671:35:42","國道一號北向82.1公里",100,24.876558,121.04609),
make("11a75d89c57c8655","327353908:0:24","國道一號北向81.1公里",100,24.875992,121.055756),
make("def62ebfa6e74199","534195519:0:72","國道一號五楊高架北向64.3公里",100,24.941029,121.19353),
make("04bfc4ca4b167e17","820453965:0:11","國道一號北向63.7公里",100,24.945833,121.19477),
make("12d383bfafe70f16","700888091:0:43","國道一號五楊高架北向38.8公里",100,25.065002,121.38388),
make("6ada24e51a883ee1","971255324:0:11","國道一號北向37公里",100,25.055336,121.402565),
};
private static WideHcopRoad.Camera make(String id,String edge,String road,int limit,double lat,double lon){
WideHcopRoad.Camera c=new WideHcopRoad.Camera(); c.id=id;c.edge=edge;c.road=road;c.limit=limit;c.lat=lat;c.lon=lon;c.dirs=new int[]{1};return c;
}
}