#include "shell.hpp"
#include "event_listener.hpp"

#include <RmlUi/Debugger.h>
#include <RmlUi/Core/ElementDocument.h>
#include <RmlUi/Core/Context.h>
#include <RmlUi/Core/Core.h>

#include <RmlUi_Backend.h>

#include <chrono>
#include <thread>
#include <sstream>
#include <format>
#include <iostream>

void describeChildren(std::stringstream& stream, Rml::Element* element, int offset, bool withSize) {
	if (element == nullptr) {
		return;
	}

	for (int i = 0; i < offset; ++i) {
		stream << ' ';
	}
	stream << element->GetTagName();
	if (withSize) {
		stream << " (" << element->GetClientWidth() << ' ' << element->GetClientHeight() << ')';
	}
	stream << '\n';
	for (int i = 0; i < element->GetNumChildren(); ++i) {
		describeChildren(stream, element->GetChild(i), offset + 2, withSize);
	}
}

std::string describeChildren(Rml::Element* element, bool withSize) {
	std::stringstream ss;
	describeChildren(ss, element, 0, withSize);
	return ss.str();
}

Rml::ElementDocument* initDocument(Rml::Context* context) {
	//return context->LoadDocument("/path/to/document.rml");// or from stream or string

	auto* doc = context->CreateDocument();
	auto vw = Rml::Property{100.0f, Rml::Unit::VW};
	auto vh = Rml::Property{100.0f, Rml::Unit::VH};
	doc->SetProperty(Rml::PropertyId::Width, vw);
	doc->SetProperty(Rml::PropertyId::Height, vh);

	auto container = doc->CreateElement("div");

	auto sz = Rml::Property{100.0f, Rml::Unit::PERCENT};
	container->SetProperty(Rml::PropertyId::Width, sz);
	container->SetProperty(Rml::PropertyId::Height, sz);
	container->SetProperty(Rml::PropertyId::Color, Rml::Property{Rml::Colourb{255, 255, 255}, Rml::Unit::COLOUR});
#if defined RMLUI_PLATFORM_EMSCRIPTEN
	container->SetProperty(Rml::PropertyId::FontFamily, Rml::Property{"rmlui-debugger-font", Rml::Unit::STRING});
#else
	container->SetProperty(Rml::PropertyId::FontFamily, Rml::Property{"roboto", Rml::Unit::STRING});
#endif
	container->SetProperty(Rml::PropertyId::FontSize, Rml::Property{40.0f, Rml::Unit::DP});
	container->SetProperty(Rml::PropertyId::BackgroundColor, Rml::Property{Rml::Colourb{0, 128, 0}, Rml::Unit::COLOUR});
	container->SetProperty("display", "block");
	//container->SetProperty(Rml::PropertyId::Display, Rml::Property{4, Rml::Unit::KEYWORD});

	auto inner = doc->CreateElement("div");
	auto mg = Rml::Property{20.0f, Rml::Unit::PERCENT};
	inner->SetProperty(Rml::PropertyId::MarginLeft, mg);
	inner->SetProperty(Rml::PropertyId::MarginRight, mg);
	inner->SetProperty(Rml::PropertyId::MarginTop, mg);
	inner->SetProperty(Rml::PropertyId::MarginBottom, mg);
	inner->SetProperty(Rml::PropertyId::Height, Rml::Property{60.0f, Rml::Unit::PERCENT});
	inner->SetProperty(Rml::PropertyId::BackgroundColor, Rml::Property{Rml::Colourb{0, 0, 128}, Rml::Unit::COLOUR});
	inner->SetProperty(Rml::PropertyId::Display, Rml::Property{1, Rml::Unit::KEYWORD});
	//inner->SetProperty("display", "block");

	auto msg_node = doc->CreateTextNode("Hello, RmlUi world!");

	inner->AppendChild(std::move(msg_node));
	container->AppendChild(std::move(inner));
	doc->AppendChild(std::move(container));

	return doc;
}

int main(int /*argc*/, char** /*argv*/) {
  const int width = 1600;
	const int height = 900;

  if (!Shell::Initialize()) {
    return -1;
  }

  if(!Backend::Initialize("Rml raw", width, height, true)) {
    Shell::Shutdown();
    return -1;
  }

  // Install the custom interfaces constructed by the backend before initializing RmlUi.
	Rml::SetSystemInterface(Backend::GetSystemInterface());
	Rml::SetRenderInterface(Backend::GetRenderInterface());

  // RmlUi initialisation.
	Rml::Initialise();

	// Create the main RmlUi context.
	Rml::Context* context = Rml::CreateContext("main", Rml::Vector2i(width, height));
	if (!context)
	{
		Rml::Shutdown();
		Backend::Shutdown();
		Shell::Shutdown();
		return -1;
	}

  Rml::Debugger::Initialise(context);

	Shell::LoadFonts();
  
	auto* document = initDocument(context);
	
	SimpleEventListener el{[](Rml::Event& event) {
		using namespace Rml;

		switch (event.GetId()) {
		case EventId::Keydown: {
			Rml::Input::KeyIdentifier key_identifier = (Rml::Input::KeyIdentifier)event.GetParameter<int>("key_identifier", 0);

			if (key_identifier == Rml::Input::KI_ESCAPE)
				Backend::RequestExit();
		}
		break;

		default: break;
		}
	}};
	document->AddEventListener(Rml::EventId::Keydown, &el);
	document->AddEventListener(Rml::EventId::Keyup, &el);
	//Note as for all raw pointers, they are non-owning. Thus, it is the user’s responsibility to keep the event listener alive until it is removed, and then to clean it up.

	int counter = 0;
	bool running = true;
	while (running) {
		//iframe->UpdateDocument();

		running = Backend::ProcessEvents(context, &Shell::ProcessKeyDownShortcuts, true);
		context->Update();

		Backend::BeginFrame();
		context->Render();
		Backend::PresentFrame();

		// if(counter % 1000 == 0) {
		// 	std::cout << describeChildren(document, true) << std::endl;
		// }
		++counter;
		std::this_thread::sleep_for(std::chrono::milliseconds(1000 / 60));
	}

	document->Close();
	document = nullptr;

	Rml::Shutdown();

	Backend::Shutdown();
	Shell::Shutdown();

	return 0;
}