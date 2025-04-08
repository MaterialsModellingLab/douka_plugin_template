# douka_plugin_template
douka plugin template

## Requirements
- douka
  - https://github.com/MaterialsModellingLab/douka.git


## Build & Install
### Build Tools
- `CMake`
- `Ninja`
- C++ Compiler
  - `C++17`

### X86 or ARM platform
Type the following command at the project root directory to build and install the plugin.
```bash
cmake --preset release
cmake --build build/release
cmake --install build/release
```
