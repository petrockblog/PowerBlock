add_library(powerblock-app STATIC
        PowerBlock.cpp
        PowerSwitch.cpp
        GPIO.cpp
        PowerBlockConfiguration.cpp
        )

target_link_libraries(powerblock-app jsoncpp_lib_static)

add_executable(${EXECUTABLE_NAME} "main.cpp")
target_link_libraries(${EXECUTABLE_NAME} powerblock-app)
target_link_libraries(${EXECUTABLE_NAME} LIOlib)