#pragma once

#include <RmlUi/Core/EventListener.h>

#include <functional>

class SimpleEventListener : public Rml::EventListener {
  public:
  using callback_t = std::function<void(Rml::Event&)>;

  SimpleEventListener(callback_t callback) : callback_{callback} {}

  virtual void ProcessEvent(Rml::Event& event) {
    if (callback_) {
      callback_(event);
    }
  }

  private:
  callback_t callback_;
};
