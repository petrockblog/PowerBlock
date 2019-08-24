cmake_minimum_required(VERSION 3.7.0)

project(PowerBlockService)

set(CMAKE_CXX_STANDARD 14)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3")

add_subdirectory("src")

#install(FILES ${CMAKE_BINARY_DIR}/${EXECUTABLE_NAME} DESTINATION /usr/bin
#        PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ
#        GROUP_EXECUTE GROUP_READ
#        )
#install(FILES ${CMAKE_BINARY_DIR}/../supplementary/powerblockconfig.cfg DESTINATION /etc
#        PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ
#        GROUP_READ
#        )
#install(FILES ${CMAKE_BINARY_DIR}/../supplementary/powerblockswitchoff.sh DESTINATION /etc
#        PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ
#        GROUP_EXECUTE GROUP_READ
#        )
#
#add_custom_target(uninstall
#        "${CMAKE_COMMAND}" -P "${CMAKE_SOURCE_DIR}/scripts/uninstall.cmake"
#        )
#
#add_custom_target(installservice
#        COMMAND ./installService.sh
#        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/scripts
#        COMMENT "Installing service."
#        )
#
#add_custom_target(uninstallservice
#        COMMAND /etc/init.d/powerblock stop
#        COMMAND update-rc.d powerblock remove
#        COMMAND rm /etc/init.d/powerblock
#        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/../scripts
#        COMMENT "Uninstalling service."
#        )

# Doxygen documentation target
add_subdirectory(doc)
