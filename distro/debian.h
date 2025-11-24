// la lógica de debian es la misma que mint LMDE y cualquier distro que use debian como upstream.
// no hay que tocar mucho por aquí para dar soporte a distros que usen debian como upstream.
// - Alexia.

#ifndef DEBIAN_H
#define DEBIAN_H

#include "common.h"

void debian_install_dependencies() {
    run("sudo apt update && sudo apt install -y "
        "build-essential libncurses-dev pkg-config libncursesw5-dev bison flex libssl-dev libelf-dev "
        "bc wget tar xz-utils gettext libc6-dev fakeroot curl git debhelper libdw-dev rsync locales");
}

void debian_build_and_install(const char* home, const char* version, const char* tag) {
    install_debian_based_kernel(home, version, tag);
}

void debian_update_bootloader() {
    debian_common_update_bootloader();
}

const char* debian_get_whiptail_install_cmd() {
    return debian_common_get_whiptail_install_cmd();
}

DistroOperations DEBIAN_OPS = {
    .name = "Debian",
    .install_dependencies = debian_install_dependencies,
    .build_and_install = debian_build_and_install,
    .update_bootloader = debian_update_bootloader,
    .get_whiptail_install_cmd = debian_get_whiptail_install_cmd
};

#endif
