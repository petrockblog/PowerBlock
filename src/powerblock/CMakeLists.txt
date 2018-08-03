add_library(powerblock-app STATIC
        PowerBlock.cpp
        PowerSwitch.cpp
        GPIO.cpp
        PowerBlockConfiguration.cpp
        )

target_link_libraries(powerblock-app jsoncpp_lib_static)
target_link_libraries(powerblock-app bcm2835)