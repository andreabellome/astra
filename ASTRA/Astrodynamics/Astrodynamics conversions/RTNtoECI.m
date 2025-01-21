function rtn2eci = RTNtoECI(rr,vv)

% DESCRIPTION
% This function converts a vector from the RTN (Radial, Transverse, Normal) 
% frame to the ECI (Earth-Centered Inertial) frame by constructing the 
% transformation matrix based on the input position and velocity vectors.
%
% INPUT
% - rr : Position vector in the ECI frame (3x1 vector).
% - vv : Velocity vector in the ECI frame (3x1 vector).
%
% OUTPUT
% - rtn2eci : 3x3 transformation matrix to convert a vector from the RTN 
%             frame to the ECI frame.
%
% -------------------------------------------------------------------------

rhat = rr/norm(rr);
Nhat = cross(rr,vv)/norm(cross(rr,vv));
that = cross(Nhat,rhat);

rtn2eci = [rhat'; that'; Nhat']';

end
