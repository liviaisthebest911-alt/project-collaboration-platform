import { Route, Routes } from "react-router-dom";
import { Users } from "lucide-react";

// Placeholder page. Replace it with the real routes (see src/routes) as features are built.
function HomePlaceholder() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center gap-3 bg-gray-50 text-gray-800">
      <Users className="h-10 w-10" />
      <h1 className="text-2xl font-semibold">Project Collaboration Platform</h1>
      <p className="text-sm text-gray-500">Project skeleton is ready. No features implemented yet.</p>
    </main>
  );
}

export default function App() {
  return (
    <Routes>
      <Route path="/" element={<HomePlaceholder />} />
    </Routes>
  );
}
