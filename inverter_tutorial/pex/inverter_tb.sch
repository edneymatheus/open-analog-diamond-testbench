v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N -10 -60 30 -60 {
lab=Vin}
N 70 -150 70 -110 {
lab=VDD}
N 70 -10 70 30 {
lab=VSS}
N 140 -60 190 -60 {
lab=Vout}
N 170 0 170 30 {
lab=VSS}
N -270 -110 -270 -80 {
lab=VSS}
N -270 -20 -270 10 {
lab=GND}
N -190 -110 -190 -80 {
lab=VDD}
N -190 -20 -190 10 {
lab=VSS}
N -110 -120 -110 -80 {
lab=Vin}
N -110 -20 -110 20 {
lab=VSS}
C {capa-2.sym} 170 -30 0 0 {name=C1
m=1
value=100f
footprint=1206
device=polarized_capacitor}
C {vsource.sym} -270 -50 0 0 {name=V1 value=0 savecurrent=false}
C {vsource.sym} -190 -50 0 0 {name=V2 value=1.5 savecurrent=false}
C {vsource.sym} -110 -50 0 0 {name=V3 value=1.5 savecurrent=false}
C {gnd.sym} -270 10 0 0 {name=l1 lab=GND}
C {lab_wire.sym} -270 -110 0 0 {name=p1 sig_type=std_logic lab=VSS}
C {lab_wire.sym} -190 10 0 0 {name=p2 sig_type=std_logic lab=VSS}
C {lab_wire.sym} -110 20 0 0 {name=p3 sig_type=std_logic lab=VSS}
C {lab_wire.sym} 70 30 0 0 {name=p4 sig_type=std_logic lab=VSS}
C {lab_wire.sym} 170 30 0 0 {name=p5 sig_type=std_logic lab=VSS}
C {lab_wire.sym} -190 -110 0 0 {name=p6 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 70 -150 0 0 {name=p7 sig_type=std_logic lab=VDD}
C {lab_wire.sym} -110 -120 0 0 {name=p8 sig_type=std_logic lab=Vin}
C {lab_wire.sym} -10 -60 0 0 {name=p9 sig_type=std_logic lab=Vin}
C {lab_wire.sym} 190 -60 0 1 {name=p10 sig_type=std_logic lab=Vout}
C {devices/code_shown.sym} -240 100 0 0 {name=MODEL only_toplevel=true
format="tcleval( @value )"
value=".lib cornerMOSlv.lib mos_tt
"}
C {code_shown.sym} 170 90 0 0 {name=SPICE only_toplevel=false value=
"
.include /home/jsmoya07/Documents/inverter_tutorial/pex/inverter.spice
.dc V3 0 1.5 0.01
.save all
"}
C {/home/jsmoya07/Documents/inverter_tutorial/pex/inverter.sym} 280 -20 0 0 {name=x1}
