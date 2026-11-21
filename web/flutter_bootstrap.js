{{flutter_js}}
{{flutter_build_config}}

const isExtension = ['chrome-extension:', 'moz-extension:'].includes(location.protocol);
if (isExtension) {
  document.documentElement.classList.add('extension-popup');
}

_flutter.loader.load({
  config: {
    canvasKitBaseUrl: new URL('canvaskit/', document.baseURI).href,
    forceSingleThreadedSkwasm: isExtension,
  },
});
