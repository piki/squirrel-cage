include <spline.scad>

OR=109/2;
IR=86/2;
T=2;
BEAMS=6;
BLADES=28;
H=26.5+T;
$fn=60;

module ring(outer_radius, inner_radius, T) {
  difference() {
      cylinder(r=outer_radius, h=T);
      translate([0,0,-T]) {
          cylinder(r=inner_radius, h=T*3);
      }
  }
}

module hub(radius, T, post_radius, post_base, post_height, DR, DR2) {
  difference() {
    union() {
      difference() {
        union() {
          ring(radius, radius-6, T);
          cylinder(h=6.3, r1=radius, r2=post_radius);
        }
        translate([0,0,-1]) {
          cylinder(h=6.8, r1=radius*0.93-T*1.5, r2=post_radius-T*2);
        }
      }
      translate([0,0,post_base]) {
        cylinder(r=post_radius, h=post_height-post_base);
      }
    }
    translate([0,0,-1]) {
      cylinder(r=DR, h=post_height+2);
    }
  }
  translate([DR2,-DR,post_base]) {
    cube([DR-DR2,2*DR,post_height-post_base]);
  }
}

module beam(outer_radius, inner_radius, width, T) {
  translate([inner_radius,-width/2,0]) {cube([outer_radius-inner_radius,width,T]);}
}

module blade(outer, inner, T, pitch) {
  path_2D = [
    [inner,0],
    [inner+(outer-inner)*0.2, 0],
    [inner+(outer-inner)*0.7, 3],
    [outer,13]
  ];
  spline_wall(path_2D, width=1.65, height=H);
}

ring(OR, IR, T);
translate([0,0,H-T]) {
  ring(OR, IR, T);
}
for (i = [0:360/BEAMS:359]) {
  rotate(i) {
    beam(OR-1, 25/2-4.9, 6, T);
    beam(IR-1, 25/2-4.9, 2.5, 4.25);
  }
}
intersection() {
  cylinder(r=OR, h=H+5);
  union() {
    for (i = [0:360/BLADES:359]) {
      rotate(i) {
        blade(OR, IR+T, T, 40);
      }
    }
  }
}
hub(25/2, T, 10/2, 7.79-5.5, 7.79, 4.97/2, 4.29-4.97/2);
