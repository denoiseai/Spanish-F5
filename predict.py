import subprocess
from cog import BasePredictor, Input, Path
import os

class Predictor(BasePredictor):
    def predict(
        self,
        ref_audio: Path = Input(description="Path to the reference audio file"),
        gen_text: str = Input(description="Text to synthesize"),
        model: str = Input(description="Model to use", default="F5-TTS"),

    ) -> Path:
        """Run F5-TTS inference and return the synthesized audio file."""
        
        # Define la ruta esperada del archivo de salida
        output_path = "tests/infer_cli_out.wav"
        
        # Construye el comando de inferencia
        command = [
            "f5-tts_infer-cli",
            "--model", model,
            "--ref_audio", str(ref_audio),
            "--gen_text", gen_text,
        ]

        # Ejecuta el comando
        result = subprocess.run(command, capture_output=True, text=True)

        if result.returncode != 0:
            raise RuntimeError(f"Error in inference: {result.stderr}")

        # Verifica si el archivo de salida existe
        if not os.path.exists(output_path):
            raise FileNotFoundError(f"Expected output file not found at {output_path}")

        # Devuelve la ruta del archivo generado para que se pueda descargar
        return Path(output_path)
