# nginx-modsecurity
Scripts to ease building nginx packages with ModSecurity for Debian-based and RPM-based systems.

There are a number of guides for building Nginx with ModSecurity but they all seem to assume that you are fine with straight compiled Nginx loaded from /usr/local/nginx with no integration into whatever distribution you might be using. I like to take advantage of whatever distribution conventions are in place so I worked up two scripts to automate the process of rebuilding distro RPMs or Debian packages with ModSecurity added in.

So far there are two scripts: one for Debian-based systems and one for RPM-based systems. In the comments in each script I've listed the package dependencies you'll need to install before you run the script and I've tested the Debian script with Debian Jessie and the RPM script with Fedora-23 but I've tried to make them generic enough that they should work with other similar distributions.

I'm operating under the assumption that you run the script from your home directory as a regular unprivileged user. This is particularly important for the RPM script as it is assuming it will use ~/rpmbuild/SPECS as its working directory after it has installed the source RPM.

The RPM script will dump its Nginx package under rpmbuild/RPMS/x86_64 while the Debian script creates an 'nginx' working directory and dumps its Nginx packages there.

Once the packages are installed, with a little tweaking you can reuse the modsecurity.conf from the ModSecurity package and the rules from the OWASP Core Rule Set package for each distribution for Nginx even though they were packaged for Apache.
