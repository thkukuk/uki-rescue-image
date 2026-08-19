This `mkosi.conf` file is for usage in OBS (Open Build Service).

It setups everything to sign the UKI in OBS and contains the complete
package list.

The `mkosi-obs-include.obscpio` can be generated with the following
script:
```sh
mkdir uki-rescue
# Hardlink the files into the new structure 
cp -al mkosi.images uki-rescue/
# Create the archive targeting the new directory
find uki-rescue -print0 | cpio -o -0 -H newc > mkosi-obs-include.obscpio
rm -rf uki-rescue
```
