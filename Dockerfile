FROM debian:11

ARG JDK_URL="https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u345-b01/OpenJDK8U-jdk_x64_linux_hotspot_8u345b01.tar.gz"
ARG JDK_SHA="ed6c9db3719895584fb1fd69fc79c29240977675f26631911c5a1dbce07b7d58"

ARG GRADLE_URL="https://services.gradle.org/distributions/gradle-4.10.3-bin.zip"
ARG GRADLE_SHA="8626cbf206b4e201ade7b87779090690447054bc93f052954c78480fa6ed186e"

RUN DEBIAN_FRONTEND=noninteractive apt-get update                             \
    && apt-get install --quiet --yes --no-install-recommends libarchive-tools \
    && apt-get clean      --quiet --yes                                       \
    && apt-get autoremove --quiet --yes                                       \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /work

ADD ${JDK_URL} "./jdk.tar.gz"
RUN echo "${JDK_SHA} ./jdk.tar.gz" | sha256sum -c -                           \
    && mkdir -p "jdk"                                                         \
    && bsdtar -x --strip-components 1 --directory "jdk" --file "./jdk.tar.gz" \
    && rm -f "./jdk.tar.gz"
ENV PATH="${PATH}:/work/jdk/bin"

ADD ${GRADLE_URL} "./gradle.zip"
RUN echo "${GRADLE_SHA} ./gradle.zip" | sha256sum -c -                           \
    && mkdir -p "gradle"                                                         \
    && bsdtar -x --strip-components 1 --directory "gradle" --file "./gradle.zip" \
    && rm -f "./gradle.zip"
ENV PATH="${PATH}:/work/gradle/bin"
