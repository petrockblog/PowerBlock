set(EXECUTABLE_NAME "powerblock")

include_directories(lib/plog/include)
include_directories(lib/jsoncpp/include)

add_subdirectory(lib/jsoncpp)
add_subdirectory(lib/plog)
add_subdirectory(powerblock)
