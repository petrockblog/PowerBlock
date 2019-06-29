cmake_minimum_required(VERSION 2.8.10)

project(PowerBlockService)

set(CMAKE_CXX_STANDARD 11)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3")
set(EXECUTABLE_NAME "powerblock")

include_directories(src/powerblock)
include_directories(src/lib/jsoncpp/include)
include_directories(src/lib/plog/include)

add_subdirectory(src/lib/jsoncpp)
add_subdirectory(src/powerblock)

find_library(wiringPi_LIB wiringPi)
if (NOT wiringPi_LIB)
    message(FATAL_ERROR "Cannot find wiringPi library.")
endif ()

add_executable(${EXECUTABLE_NAME} "src/powerblock/main.cpp")
target_link_libraries(${EXECUTABLE_NAME} powerblock-app)
target_link_libraries(${EXECUTABLE_NAME} ${wiringPi_LIB})

install(FILES ${CMAKE_BINARY_DIR}/${EXECUTABLE_NAME} DESTINATION /usr/bin
        PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ
        GROUP_EXECUTE GROUP_READ
        )
install(FILES ${CMAKE_BINARY_DIR}/../supplementary/powerblockconfig.cfg DESTINATION /etc
        PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ
        GROUP_READ
        )
install(FILES ${CMAKE_BINARY_DIR}/../supplementary/powerblockswitchoff.sh DESTINATION /etc
        PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ
        GROUP_EXECUTE GROUP_READ
        )

add_custom_target(uninstall
        "${CMAKE_COMMAND}" -P "${CMAKE_SOURCE_DIR}/scripts/uninstall.cmake"
        )

add_custom_target(installservice
        COMMAND ./installService.sh
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/scripts
        COMMENT "Installing service."
        )

add_custom_target(uninstallservice
        COMMAND /etc/init.d/powerblock stop
        COMMAND update-rc.d powerblock remove
        COMMAND rm /etc/init.d/powerblock
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/../scripts
        COMMENT "Uninstalling service."
        )

# Doxygen documentation target
add_subdirectory(doc)
