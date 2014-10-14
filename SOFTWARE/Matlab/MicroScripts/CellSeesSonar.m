function [ output ] = CellSeesSonar( cell_start_angle,cell_end_angle,beam_start_angle,beam_mid_angle,beam_end_angle,shift )
%CELLSEESSONAR Summary of this function goes here
%   Detailed explanation goes here
output = 0;
cell_start_angle = WrapAngle(cell_start_angle + shift);
cell_end_angle = WrapAngle(cell_end_angle + shift);
beam_start_angle = WrapAngle(beam_start_angle + shift);
beam_mid_angle = WrapAngle(beam_mid_angle + shift);
beam_end_angle = WrapAngle(beam_end_angle + shift);
if (beam_mid_angle > cell_start_angle) && (beam_mid_angle < cell_end_angle)
    output = 1;
end
end

