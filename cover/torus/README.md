The torus image on the front cover was generated with
scripts from this directory. Here is how:

1. An image `torus.jpg` of torus is generated with Mathematica, see `Torus.nb`.
2. Images of symbols are generated with `symbols.py`.
3. Metapixel is used to create the torus image, maybe like this:

       rm -rf srcimg/* dstimg/* && metapixel-prepare srcimg dstimg
       metapixel -d 1 -s 3 -w 128 -h 128 -l dstimg --metapixel torus.jpg mosaic-torus.png

4. The resulting mosaic-torus.png is then cropped and given color with Gimp.
