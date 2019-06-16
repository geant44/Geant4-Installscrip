#auther:Further
#version 2 fix some problem,data and source into the one file
#version 3 fix auto add bashrc
#version 4 fix some error for centos
#version 5 change envirent value
#version 6 change value
#version 7 add PTSIM in the file.
#version 8 add g4mpi and isntall openmpi package
#version 9 fix yum repo check function

## THis is for the geant4.10.2.2 and PTSproject-103-002-001-20170925

sudo apt update

sudo apt -y install build-essential libexpat1-dev libgl1-mesa-dev libglu1-mesa-dev libxt-dev xorg-dev libgdcm-tools 

export Geant4=$(pwd)
export GEANT4_VERSION=10.02.p02

tar Jxvf geant4.10.2.2.txz

mkdir geant4.$GEANT4_VERSION-build

cd $Geant4/geant4.$GEANT4_VERSION-build

cmake3 -DCMAKE_INSTALL_PREFIX=$Geant4/geant4.$GEANT4_VERSION-install -DGEANT4_USE_GDML=ON -DGEANT4_INSTALL_DATA=ON -DGEANT4_USE_OPENGL_X11=ON -DGEANT4_USE_XM=ON -DGEANT4_USE_QT=ON -DGEANT4_BUILD_MULTITHREADED=OFF -DGEANT4_USE_SYSTEM_EXPAT=ON -DGEANT4_USE_SYSTEM_ZLIB=ON $Geant4/geant4.$GEANT4_VERSION

make -j`grep -c processor /proc/cpuinfo`
make install

#mkdir /usr/share/Modules/modulefiles/geant4
#cp geant4.$GEANT4_VERSION-install/share/Geant4-10.2.2/geant4-10.2.2 /usr/share/Modules/modulefiles/geant4/$GEANT4_VERSION

echo "source $Geant4/geant4.$GEANT4_VERSION-install/bin/geant4.sh">>~/.bashrc
#echo "module load geant4/$GEANT4_VERSION">>~/.bashrc

source $Geant4/geant4.$GEANT4_VERSION-install/bin/geant4.sh

cd $Geant4
mkdir  g4.$GEANT4_VERSION-mpi-build
cd g4.$GEANT4_VERSION-mpi-build
module load mpi/openmpi-x86_64
cmake3 -DCMAKE_INSTALL_PREFIX=$Geant4/geant4.$GEANT4_VERSION-install ../geant4.10.02.p02/examples/extended/parallel/MPI/source
make -j`grep -c processor /proc/cpuinfo`
make install

cd $Geant4
tar vxzf PTSproject-102-000-000-20160115.tar.gz
cd PTSproject
cp script/buildDynamicIAEAMPI.sh .
sed -i s/make/make\ -j`grep -c processor /proc/cpuinfo`/g buildToolkitIAEA.sh
sed -i s/make/make\ -j`grep -c processor /proc/cpuinfo`/g buildDynamicIAEAMPI.sh
./buildToolkitIAEA.sh
./buildDynamicIAEAMPI.sh

cd $Geant4
tar vxzf root_v6.12.06.Linux-centos7-x86_64-gcc4.8.tar.gz
echo "source $Geant4/root/bin/thisroot.sh" >> ~/.bashrc
echo "module load mpi" >> ~/.bashrc
