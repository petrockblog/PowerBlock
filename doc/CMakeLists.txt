option(BUILD_DOCUMENTATION "Create and install the HTML based API documentation (requires Doxygen)" ON)

IF (BUILD_DOCUMENTATION)
    FIND_PACKAGE(Doxygen)
    IF (NOT DOXYGEN_FOUND)
        MESSAGE(FATAL_ERROR "Doxygen is needed to build the documentation.")
    ENDIF ()

    SET(doxyfile_in ${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.in)
    SET(doxyfile ${PROJECT_BINARY_DIR}/Doxyfile)
    SET(doxy_html_index_file ${CMAKE_CURRENT_BINARY_DIR}/htmlDoc/index.html)
    SET(doxy_output_root ${CMAKE_CURRENT_SOURCE_DIR}/htmlDoc/) # Pasted into Doxyfile.in
    SET(doxy_input ${PROJECT_SOURCE_DIR}/src/controlblock) # Pasted into Doxyfile.in
    SET(doxy_extra_files "") # Pasted into Doxyfile.in
#    SET(doxy_extra_files ${CMAKE_CURRENT_SOURCE_DIR}/mainpage.dox) # Pasted into Doxyfile.in

    CONFIGURE_FILE(${doxyfile_in} ${doxyfile} @ONLY)

    ADD_CUSTOM_COMMAND(
            OUTPUT ${doxy_html_index_file}
            COMMAND ${DOXYGEN_EXECUTABLE} ${doxyfile}
            # The following should be ${doxyfile} only but it
            # will break the dependency.
            # The optimal solution would be creating a
            # custom_command for ${doxyfile} generation
            # but I still have to figure out how...
            MAIN_DEPENDENCY ${doxyfile} ${doxyfile_in}
            DEPENDS ${EXECUTABLE_NAME} ${doxy_extra_files}
            COMMENT "Generating HTML documentation"
    )

    ADD_CUSTOM_TARGET(doc ALL DEPENDS ${doxy_html_index_file})

#    INSTALL(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/html DESTINATION share/doc)
ENDIF ()