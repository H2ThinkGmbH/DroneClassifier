function audioOut = normalizeAudioInput(audioIn, normalizationFactor)
    audioOut = normalizationFactor*audioIn/max(audioIn(:));
end