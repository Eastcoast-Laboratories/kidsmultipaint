/**
 * 2_5_chord_characters.js - Module for the "Chord Characters" activity
 */

// Import debug utilities
import { debugLog } from '../../utils/debug.js';

/**
 * Test function to verify module import is working correctly
 * @returns {boolean} True if import successful
 */
export function testChordCharactersModuleImport() {
  debugLog('CHORDS', 'Chord Characters module successfully imported');
  return true;
}

/**
 * Updates the background image based on progress in the character matching activity
 * @param {Object} component - The Alpine component instance
 */
export function updateCharacterBackground(component) {
  try {
    // Get progress from localStorage or component state
    const progressData = localStorage.getItem('kidsmultipaint_chords_progress');
    const progress = progressData ? 
      JSON.parse(progressData)['2_5_chords_characters'] || 0 : 
      component?.progress?.['2_5_chords_characters'] || 0;
    
    let backgroundImage;
    
    // Progress thresholds change at exactly 10 and 20 successes
    if (progress <= 9) { // Change at exactly 10
      backgroundImage = './images/backgrounds/2_5_chords_dog_cat_owl_no_squirrel_no_octopus.jpg';
      
      // Preload next background when approaching transition point
      if (progress === 9) {
        preloadBackgroundImage('./images/backgrounds/2_5_chords_dog_cat_owl_squirrel_no_octopus.jpg');
      }
    } else if (progress <= 19) { // Change at exactly 20
      backgroundImage = './images/backgrounds/2_5_chords_dog_cat_owl_squirrel_no_octopus.jpg';
      
      // Preload next background when approaching transition point
      if (progress === 19) {
        preloadBackgroundImage('./images/backgrounds/2_5_chords_dog_cat_owl_squirrel_octopus.jpg');
      }
    } else {
      backgroundImage = './images/backgrounds/2_5_chords_dog_cat_owl_squirrel_octopus.jpg';
    }
    
    // Update the background
    const characterActivity = document.querySelector('[x-show="mode === \'2_5_chords_characters\'"]');
    if (characterActivity) {
      characterActivity.style.backgroundImage = `url(${backgroundImage})`;
      debugLog(['CHORDS', '2_5_BACKGROUND'], `Updated background based on progress (${progress}): ${backgroundImage}`);
    } else {
      debugLog(['CHORDS', 'ERROR'], 'Error updating background: div not found');
    }
  } catch (error) {
    debugLog(['CHORDS', 'ERROR'], `Error in updateCharacterBackground: ${error.message}`);
  }
}

/**
 * Preloads a background image for smoother transitions
 * @param {string} imageUrl - The URL of the image to preload
 */
function preloadBackgroundImage(imageUrl) {
  const img = new Image();
  img.src = imageUrl;
  debugLog(['CHORDS', '2_5_BACKGROUND'], `Preloading background image: ${imageUrl}`);
}

/**
 * Reset progress for Chord Types activity (2_5)
 * @param {Object} component - The pitches component instance
 */
export function reset_2_5_ChordTypes_Progress(component) {
  console.log('Resetting Chord Types progress...');
  
  // Clear localStorage data
  localStorage.removeItem('kidsmultipaint_chords_progress');
  
  // Reset any in-memory state if applicable
  if (component && component.chords) {
    if (component.chords.chordsProgress) {
      component.chords.chordsProgress = 0;
    }
  }
  
  console.log('Chord Types progress reset complete');
}

