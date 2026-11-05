import { BrowserMultiFormatReader } from '@zxing/browser';

const initScan = () => {
  const videoElement = document.getElementById('scan-video');
  if (!videoElement) return;

  const codeReader = new BrowserMultiFormatReader();

  codeReader.decodeFromVideoDevice(undefined, videoElement, (result, error, controls) => {
    if (result) {
      const myInput = document.getElementById('scan_barcode');
      const myForm = document.querySelector('.simple_form');
      myInput.value = result.getText();
      controls.stop();
      myForm.submit();
    }
  }).catch((error) => {
    console.error('Unable to access camera for barcode scan:', error);
  });
};

export { initScan };
