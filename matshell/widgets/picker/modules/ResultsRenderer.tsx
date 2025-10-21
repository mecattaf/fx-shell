import { createBinding, createComputed, For, With } from "ags";
import { Gtk } from "ags/gtk4";
import { PickerCoordinator } from "utils/picker/PickerCoordinator";
import { WallpaperItem } from "utils/picker/types";
import { ItemButton } from "./ItemButton";
import { WallpaperGrid } from "./WallpaperGrid";
import { CommandSuggestions } from "./CommandSuggestions";
import { ThemeControls } from "./ThemeControls";

interface ResultsRendererProps {
  picker: PickerCoordinator;
}

export function ResultsRenderer({ picker }: ResultsRendererProps) {
  const hasQuery = createBinding(picker, "hasQuery");
  const isLoading = createBinding(picker, "isLoading");
  const hasResults = createBinding(picker, "hasResults");
  const searchText = createBinding(picker, "searchText");
  const viewState = createComputed(
    [hasQuery, isLoading, hasResults, searchText],
    () => {
      const text = searchText.get();

      if (text.startsWith(":")) return "commands";
      if (!hasQuery.get() && !hasResults.get()) return "empty";
      if (isLoading.get()) return "loading";
      if (hasResults.get()) return "results";
      return "not-found";
    },
  );
  return (
    <box orientation={Gtk.Orientation.VERTICAL}>
      <box
        cssClasses={["results-container"]}
        orientation={Gtk.Orientation.VERTICAL}
      >
        <With value={viewState}>
          {(state) => {
            switch (state) {
              case "loading":
                return <LoadingState />;
              case "commands":
                return <CommandSuggestions picker={picker} />;
              case "results":
                return <ResultsContainer picker={picker} />;
              case "not-found":
                return <NotFoundState query={picker.searchText} />;
              case "empty":
                return <EmptyState />;
              default:
                return <box />;
            }
          }}
        </With>
        <With value={viewState}>
          {(state) => state !== "empty" && <ActionBar picker={picker} />}
        </With>
      </box>
    </box>
  );
}

function LoadingState() {
  return (
    <box
      halign={Gtk.Align.CENTER}
      cssClasses={["loading-state"]}
      orientation={Gtk.Orientation.VERTICAL}
    >
      <label label="Loading..." />
    </box>
  );
}

function ResultsContainer({ picker }: { picker: PickerCoordinator }) {
  const currentResults = createBinding(picker, "currentResults");
  const config = picker.currentConfig;

  if (config?.component === "grid") {
    return (
      <box cssClasses={["results-grid"]}>
        <With value={currentResults}>
          {(items) => (
            <WallpaperGrid items={items as WallpaperItem[]} picker={picker} />
          )}
        </With>
      </box>
    );
  }

  // Default to list
  return (
    <box
      cssClasses={["results-list"]}
      orientation={Gtk.Orientation.VERTICAL}
      spacing={4}
    >
      <For each={currentResults}>
        {(item, index) => (
          <ItemButton item={item} picker={picker} index={index} />
        )}
      </For>
    </box>
  );
}

function NotFoundState({ query }: { query: string }) {
  return (
    <box
      halign={Gtk.Align.CENTER}
      cssClasses={["not-found"]}
      orientation={Gtk.Orientation.VERTICAL}
    >
      <image iconName="system-search-symbolic" />
      <label label={`No results found for "${query}"`} />
    </box>
  );
}

function EmptyState() {
  return (
    <box
      halign={Gtk.Align.CENTER}
      cssClasses={["not-found"]}
      orientation={Gtk.Orientation.VERTICAL}
    >
      <image iconName="system-search-symbolic" />
      <label label="Search & select to populate your favorites based on frecency" />
    </box>
  );
}

function ActionBar({ picker }: { picker: PickerCoordinator }) {
  const config = picker.currentConfig;
  const hasActions = config?.features?.refresh || config?.features?.random;

  if (!hasActions) {
    return <box />;
  }

  return (
    <box cssClasses={["action-bar"]} spacing={8}>
      {config?.features?.refresh && (
        <button
          cssClasses={["action-button"]}
          onClicked={() => picker.refresh()}
        >
          <label
            label="Refresh"
            tooltipText={"Reload"}
            cssClasses={["action-icon"]}
          />
        </button>
      )}
      <ThemeControls picker={picker} />
      {config?.features?.random && (
        <button
          cssClasses={["action-button"]}
          onClicked={() => picker.random()}
        >
          <label
            label="Shuffle"
            tooltipText={"Select randomly"}
            cssClasses={["action-icon"]}
          />
        </button>
      )}
      {config?.features?.wipe && (
        <button
          cssClasses={["action-button"]}
          tooltipText={"Purge history"}
          onClicked={() => picker.wipe()}
        >
          <label label="Delete_History" cssClasses={["action-icon"]} />
        </button>
      )}
    </box>
  );
}
