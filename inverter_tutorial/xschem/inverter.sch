v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N -80 -270 -80 -240 {
lab=Vout}
N -160 -320 -120 -320 {
lab=Vin}
N -160 -270 -160 -210 {
lab=Vin}
N -160 -210 -120 -210 {
lab=Vin}
N -80 -380 -80 -350 {
lab=VDD}
N -80 -320 -30 -320 {
lab=VDD}
N -30 -380 -30 -320 {
lab=VDD}
N -80 -380 -30 -380 {
lab=VDD}
N -80 -390 -80 -380 {
lab=VDD}
N -80 -150 -80 -140 {
lab=xxx}
N -80 -210 -30 -210 {
lab=xxx}
N -30 -210 -30 -150 {
lab=xxx}
N -80 -150 -30 -150 {
lab=xxx}
N -80 -180 -80 -150 {
lab=xxx}
N -200 -270 -160 -270 {
lab=Vin}
N -160 -320 -160 -270 {
lab=Vin}
N -80 -270 -40 -270 {
lab=Vout}
N -80 -290 -80 -270 {
lab=Vout}
C {sg13g2_pr/sg13_lv_nmos.sym} -100 -210 0 0 {name=M1
l=0.13u
w=1u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_pmos.sym} -100 -320 0 0 {name=M2
l=0.13u
w=3u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {ipin.sym} -200 -270 0 0 {name=p1 lab=Vin}
C {iopin.sym} -80 -390 0 0 {name=p2 lab=VDD}
C {iopin.sym} -40 -270 0 0 {name=p3 lab=Vout}
C {iopin.sym} -80 -140 0 0 {name=p4 lab=VSS}
