const getImageJs = """
async function getImage(src) {
  try {
    const res = await fetch(src);
    const blob = await res.blob();

    return await new Promise((resolve) => {
      const reader = new FileReader();

      reader.onloadend = () => resolve(reader.result || "l");
      reader.onabort = () => resolve("a");
      reader.onerror = () => resolve("oe");

      reader.readAsDataURL(blob);
    });
  } catch (_) {
    return "e";
  }
}
""";
