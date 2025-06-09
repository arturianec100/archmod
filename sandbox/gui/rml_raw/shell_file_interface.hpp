#pragma once

#include "RmlUi/Core/FileInterface.h"
#include "RmlUi/Core/Types.h"

#include <cstdio>

class ShellFileInterface : public Rml::FileInterface {
public:
	ShellFileInterface(const Rml::String& root) : root(root) {}
	virtual ~ShellFileInterface() {}

	Rml::FileHandle Open(const Rml::String& path) override {
    // Attempt to open the file relative to the application's root.
    FILE* fp = fopen((root + path).c_str(), "rb");
    if (fp != nullptr)
      return (Rml::FileHandle)fp;

    // Attempt to open the file relative to the current working directory.
    fp = fopen(path.c_str(), "rb");
    return (Rml::FileHandle)fp;
  }

	void Close(Rml::FileHandle file) override {
    fclose((FILE*)file);
  }

	size_t Read(void* buffer, size_t size, Rml::FileHandle file) override {
    return fread(buffer, 1, size, (FILE*)file);
  }

	bool Seek(Rml::FileHandle file, long offset, int origin) override {
    return fseek((FILE*)file, offset, origin) == 0;
  }

	size_t Tell(Rml::FileHandle file) override {
    return ftell((FILE*)file);
  }

private:
	Rml::String root;
};
