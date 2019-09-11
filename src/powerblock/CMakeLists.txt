add_library(powerblock-app STATIC
        PowerBlock.cpp
        PowerSwitch.cpp
        PowerBlockConfiguration.cpp
        )

target_link_libraries(powerblock-app jsoncpp_lib_static)

add_executable(${EXECUTABLE_NAME} "main.cpp")
target_link_libraries(${EXECUTABLE_NAME} powerblock-app)
target_link_libraries(${EXECUTABLE_NAME} LIOlib)

install(FILES ${CMAKE_BINARY_DIR}/src/powerblock/${EXECUTABLE_NAME} DESTINATION /usr/bin
        PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ
        GROUP_EXECUTE GROUP_READ
        )
