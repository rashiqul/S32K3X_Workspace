import os
from pathlib import Path
from subprocess import check_output

from conan import ConanFile
from conan.tools.cmake import CMake, cmake_layout
from conan.tools.files import copy
from conan.errors import ConanException


class S32K3xWorkspaceConan(ConanFile):
    name = "s32k3x_workspace"
    description = "S32K3X Workspace for NXP S32K358x Microcontroller"
    license = "MIT"
    url = "https://github.com/rashiqul/S32K3X_Workspace"
    homepage = "https://github.com/rashiqul/S32K3X_Workspace"
    topics = ("embedded", "s32k3", "nxp", "automotive")

    settings = "os", "compiler", "build_type", "arch"
    package_type = "library"
    no_copy_source = True
    generators = "CMakeDeps", "CMakeToolchain"

    options = {
        "shared": [True, False],
        "fPIC": [True, False],
        "coverage": [True, False],
        "header_only": [True, False],
    }
    default_options = {
        "shared": False,
        "fPIC": True,
        "coverage": False,
        "header_only": True,
    }
    implements = (
        "auto_shared_fpic",
        "auto_header_only",
    )

    exports_sources = (
        "include/*",
        "CMakeLists.txt",
        "LICENSE",
        "README.md",
        "cmake/*",
        "scripts/*",
        "docs/*",
        "src/*",
        "test/*",
        "!.conan2*/",
        "!.git/*",
        "!bsp/*",
        "!build/*",
    )

    def requirements(self):
        pass

    def build_requirements(self):
        self.test_requires("gtest/1.14.0")

    def configure(self):
        if self.options.shared:
            del self.options.fPIC

    def config_options(self):
        if self.settings.os == "Windows":
            del self.options.fPIC

    @property
    def _root_folder(self):
        return Path(self.recipe_folder)

    @property
    def _scripts_folder(self):
        return self._root_folder / "scripts"

    @property
    def _should_test(self):
        # See https://github.com/conan-io/conan/issues/11969
        should_test = os.environ.get("CONAN_RUN_TESTS", "1").lower()
        return should_test in ("yes", "true", "t", "1")

    @property
    def _should_build(self):
        should_build = os.environ.get("CONAN_BUILD", "1").lower()
        return should_build in ("yes", "true", "t", "1")

    @property
    def _custom_target(self):
        return os.environ.get("CONAN_CUSTOM_TARGET", None)

    @property
    def _install_path(self):
        return Path(self.build_folder) / self.folders.package

    def set_version(self):
        if self.version:
            return
        try:
            version_script = self._scripts_folder / "version"
            self.version = check_output(version_script, text=True).strip()
        except Exception as e:
            # Fallback to default version if script fails
            self.output.warning(f"Failed to get version from script: {e}")
            self.version = "0.1.0"

    def _get_arch(self):
        # x86_64 architecture for local development/testing
        return self.settings.arch

    def layout(self):
        self.folders.root = self._root_folder
        self.folders.package = "package"
        cmake_layout(self, build_folder=f"build_{self._get_arch()}")

    def generate(self):
        # Local development - no external dependencies required
        pass

    def build(self):
        cmake = CMake(self)
        cmake.configure(
            variables={
                "CMAKE_INSTALL_PREFIX": self._install_path,
                "COVERAGE": "ON" if self.options.coverage else "OFF",
                "CONAN_PACKAGE_VERSION": str(self.version),
            },
        )

        if self._custom_target is not None:
            cmake.build(target=self._custom_target)
        elif self._should_build:
            cmake.build()

        if self._should_test:
            # Run tests with output on failure
            try:
                cmake.ctest(
                    cli_args=[
                        "--output-on-failure",
                        "--progress",
                        "--output-junit",
                        "gtest_junit_ut_cicd.xml",
                    ]
                )
            except ConanException as e:
                # Log error but continue to generate coverage reports
                self.output.error(f"Tests failed with exit code {e}")

    def package(self):
        # Copy license
        copy(self, "LICENSE", src=self.source_folder, dst=os.path.join(self.package_folder, "licenses"))
        
        # Copy headers from include directory
        copy(self, "*.h", src=os.path.join(self.source_folder, "include"), dst=os.path.join(self.package_folder, "include"), keep_path=True)
        copy(self, "*.hpp", src=os.path.join(self.source_folder, "include"), dst=os.path.join(self.package_folder, "include"), keep_path=True)
        
        # Copy generated config.h from build folder
        config_h = os.path.join(self.build_folder, "config.h")
        if os.path.exists(config_h):
            copy(self, "config.h", src=self.build_folder, dst=os.path.join(self.package_folder, "include"))
        
        # NOTE: Libraries are not packaged because the current CMake build produces
        # s32k3x_main library which contains a main() entry point. Shipping this would
        # cause "multiple definition of main" errors for consumers.
        # If library packaging is needed in the future, ensure only libraries without
        # entry points are packaged (e.g., create a separate library target without main).

    def package_info(self):
        # No libraries are packaged to avoid main() symbol conflicts
        self.cpp_info.libs = []
