function [ vvinf ] = azimuthElev2vinf( vinf, th, phi )

vvinf = vinf.*[ cos(phi)*cos(th), cos(phi)*sin(th), sin(phi) ];

end