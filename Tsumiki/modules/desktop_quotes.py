from fabric.utils import invoke_repeater
from fabric.widgets.box import Box
from fabric.widgets.label import Label
from fabric.widgets.wayland import WaylandWindow as Window

from services.quotes import QuotesService
from utils.functions import convert_seconds_to_milliseconds
from utils.widget_settings import BarConfig


class DesktopQuote(Window):
    """
    A simple desktop quote widget.
    """

    def __init__(self, config: BarConfig, **kwargs):
        self.config = config.get("modules", {}).get("desktop_quotes", {})

        self.quote_label = Label(
            name="desktop_quotes-quote-label",
            label="Loading quote...",
            line_wrap="word-char",
            chars_width=50,
            h_expand=True,
        )

        self.author_label = Label(
            name="desktop_quotes-author-label",
            label="Loading author...",
            line_wrap="word-char",
            chars_width=40,
            h_align="end",
            justification="right",
            h_expand=True,
        )

        super().__init__(
            name="desktop_quotes",
            layer=self.config.get("layer", "top"),
            anchor=self.config.get("anchor", "center"),
            child=Box(
                name="desktop_quotes-box",
                orientation="v",
                children=(self.quote_label, self.author_label),
            ),
            **kwargs,
        )

        self.quote_service = QuotesService()
        self.update_quote()

        invoke_repeater(
            convert_seconds_to_milliseconds(self.config.get("update_interval", 600)),
            self.update_quote,
        )

    def update_quote(self):
        """Fetch and update the quote label."""
        quote = self.quote_service.get_quotes()
        if quote:
            self.quote_label.set_label(quote["q"])
            self.author_label.set_label("- " + quote["a"])
        else:
            self.quote_label.set_text("Failed to load quote.")
        return True  # Keep the repeater running
