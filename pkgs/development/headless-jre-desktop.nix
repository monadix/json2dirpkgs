{
  jre_minimal,
  jdk_headless,
  buildPackages,
}:

jre_minimal.override {
  jdk = jdk_headless;
  jdkOnBuild = buildPackages.jdk_headless;
  modules = [
    "java.base"
    "java.desktop"
    "java.logging"
  ];
}
