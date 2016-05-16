CC=gcc-4.9
CXX=g++-4.9
SRCDIR=.
BUILDDIR=../../build
LIBJSONCPP_DIR=../lib/jsoncpp
LIBJSONCPP_INCDIR=$(LIBJSONCPP_DIR)/include
LIBJSONCPP_LIBDIR=$(LIBJSONCPP_DIR)/build/release/lib
LIBBCM2835_DIR=../lib/bcm2835-1.39
LIBBCM2835_INCDIR=$(LIBBCM2835_DIR)/src
LIBBCM2835_LIBDIR=$(LIBBCM2835_DIR)/src
LIBS=-ljsoncpp -lbcm2835 -L$(LIBJSONCPP_LIBDIR) -I$(LIBJSONCPP_INCDIR) -L$(LIBBCM2835_LIBDIR) -I$(LIBBCM2835_INCDIR) -lrt -lpthread
CFLAGS=-c -Wall -std=c++11 -O3 -I$(LIBJSONCPP_INCDIR) -I$(LIBBCM2835_INCDIR)

TARGET := powerblock
SRCEXT := cpp
SOURCES := $(shell find $(SRCDIR) -type f -name "*.$(SRCEXT)")
OBJECTS := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.$(SRCEXT)=.o))
DEPS := $(OBJECTS:.o=.deps)

all $(BUILDDIR)/$(TARGET): $(LIBJSONCPP_LIBDIR)/libjsoncpp.a $(LIBBCM2835_LIBDIR)/libbcm2835.a $(OBJECTS)
	@echo " Linking..."; $(CXX) $^ $(LIBS) -o $(BUILDDIR)/$(TARGET)

$(BUILDDIR)/%.o: $(SRCDIR)/%.$(SRCEXT)
	@mkdir -p $(BUILDDIR)
	@echo " CXX $<"; $(CXX) $(CFLAGS) -MD -MF $(@:.o=.deps) -c -o $@ $<
	
$(LIBJSONCPP_LIBDIR)/libjsoncpp.a:
	cd $(LIBJSONCPP_DIR)/ && mkdir -p build/release
	cd $(LIBJSONCPP_DIR)/build/release && cmake -DCMAKE_BUILD_TYPE=release -DJSONCPP_LIB_BUILD_SHARED=OFF -G "Unix Makefiles" ../..
	cd $(LIBJSONCPP_DIR)/build/release && make  

$(LIBBCM2835_LIBDIR)/libbcm2835.a:
	cd ../lib && tar zxvf bcm2835-1.39.tar.gz
	cd $(LIBBCM2835_DIR) && ./configure
	cd $(LIBBCM2835_DIR) && $(MAKE)

check:
	# TO BE DONE! JUST A DUMMY FOR NOW
	@echo "*** NO TESTS IMPLEMENTED ***"

clean:
	@echo " Cleaning..."; $(RM) -r $(BUILDDIR)/$(TARGET)

-include $(DEPS)

install:
	install -d $(DESTDIR)$(bindir)
	install -m 0755 $(BUILDDIR)/$(TARGET) $(DESTDIR)$(bindir)
	install -m 0755 ../../supplementary/powerblockconfig.cfg $(DESTDIR)/$(sysconfdir)

uninstall:
	-rm $(DESTDIR)$(bindir)/$(TARGET)
	-rm $(DESTDIR)$(sysconfdir)/powerblockconfig.cfg

.PHONY: clean install uninstall
