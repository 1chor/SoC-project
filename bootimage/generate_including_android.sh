function pretty_header() {
		msg="# $* #"
		edge=$(echo "$msg" | sed 's/./#/g')
		echo "$edge"
		echo "$msg"
		echo "$edge"
}

#sh generate_without_android.sh

cd ..

if [ ! -f repo ]; then

	pretty_header "Fetching repo"
	
	curl https://storage.googleapis.com/git-repo-downloads/repo > repo
	
	chmod +x repo
	
fi

export PATH=$PATH:`pwd`

if [ ! -d android ]; then
	
	pretty_header "Fetching android source"
	
	mkdir android
	
	cd android
	
	repo init -u git://github.com/MentorEmbedded/mpsoc-manifest.git -b zynqmp-android_8 -m release_android-8_xilinx-v2018.1.xml
	
	repo sync -c
	
	cd ..
	
fi

pretty_header "Making android"

cd android

source build/envsetup.sh

lunch zcu102-eng

make -j
