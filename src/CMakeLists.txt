set(EXECUTABLE_NAME "powerblock")

include_directories(lib/plog/include)
include_directories(lib/jsoncpp/include)
include_directories(lib/LIO/src)

add_subdirectory(lib/jsoncpp)
add_subdirectory(lib/LIO/src)
add_subdirectory(powerblock)
