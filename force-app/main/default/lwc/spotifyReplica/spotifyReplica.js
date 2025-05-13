/* 
* @description 
* this component is used to allow user to search for songs , artists and albums 
*  it will retrieve the data from the spotify api via rapid api .
* 
* @author : Sudheer Kumar 
*/

import { LightningElement, track, api } from 'lwc';
import searchSpotify from '@salesforce/apex/SpotifyController.searchSpotify';
import getTrackPreview from '@salesforce/apex/SpotifyController.getTrackPreview';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SpotifyReplica extends LightningElement {
    @track searchQuery = '';
    @track isLoading = false;
    @track results = [];
    @track currentTrackData = null;
    @track isPlayerVisible = false;
    @track audioUrl = null;
    @track debugInfo = ''; 
    
    defaultImageUrl = 'https://placehold.co/60x60?text=No+Image';
    currentTrackId = null;
    audioElement = null;

    handleKeyPress(event) {
        if (event.keyCode === 13) {
            this.handleSearch();
        }
    }

    get hasResults() {
        return this.results.length > 0;
    }

    handleSearchChange(event) {
        this.searchQuery = event.target.value;
    }

    handleSearch() {
        if (!this.searchQuery) return;
        this.isLoading = true;

        searchSpotify({ query: this.searchQuery })
            .then((data) => {
                this.isLoading = false;
                this.results = [];
                if (data) {
                    try {
                        const parsedData = JSON.parse(data);
                        this.processResults(parsedData);
                    } catch (error) {
                        console.error('Error parsing data:', error);
                        this.showToast('Error', 'Failed to parse search results', 'error');
                    }
                }
            })
            .catch((error) => {
                this.isLoading = false;
                console.error('Error:', error);
                this.showToast('Error', 'Search failed', 'error');
            });
    }

    handleImageError(event) {
        event.target.src = this.defaultImageUrl;
    }
    
    processResults(data) {
        
        const getSafe = (obj, path) => {
            try {
                return path.split('.').reduce((o, p) => (o && o[p] !== undefined) ? o[p] : null, obj);
            } catch (e) {
                return null;
            }
        };

        
        const albums = [];
        if (data.albums && Array.isArray(data.albums.items)) {
            data.albums.items.forEach(item => {
                if (item && item.data) {
                    const artistNames = [];
                    if (item.data.artists && Array.isArray(item.data.artists.items)) {
                        item.data.artists.items.forEach(artist => {
                            if (artist && artist.profile && artist.profile.name) {
                                artistNames.push(artist.profile.name);
                            }
                        });
                    }
                    
                    const imageUrl = getSafe(item, 'data.coverArt.sources.0.url') || this.defaultImageUrl;
                    
                    albums.push({
                        id: item.data.uri || `album-${Date.now()}`,
                        name: item.data.name || 'Unknown Album',
                        artist: artistNames.join(', ') || 'Unknown Artist',
                        image: imageUrl,
                        previewUrl: null, 
                        isAlbum: true,       
                        isPlaying: false,
                        type: 'album'
                    });
                }
            });
        }

        
        const tracks = [];
        if (data.tracks && Array.isArray(data.tracks.items)) {
            data.tracks.items.forEach(item => {
                if (item && item.data) {
                    const artistNames = [];
                    if (item.data.artists && Array.isArray(item.data.artists.items)) {
                        item.data.artists.items.forEach(artist => {
                            if (artist && artist.profile && artist.profile.name) {
                                artistNames.push(artist.profile.name);
                            }
                        });
                    }
                    
                    const imageUrl = getSafe(item, 'data.albumOfTrack.coverArt.sources.0.url') || this.defaultImageUrl;
                    
                    const trackId = getSafe(item, 'data.id') || '';
                    
                    tracks.push({
                        id: trackId || `track-${Date.now()}`,
                        name: item.data.name || 'Unknown Track',
                        artist: artistNames.join(', ') || 'Unknown Artist',
                        image: imageUrl,
                        previewUrl: null,
                        isTrack: true,
                        isPlaying: false,
                        type: 'track',
                        uri: getSafe(item, 'data.uri') || ''
                    });
                }
            });
        }

       
        const artists = [];
        if (data.artists && Array.isArray(data.artists.items)) {
            data.artists.items.forEach(item => {
                if (item && item.data && item.data.profile) {
                    const imageUrl = getSafe(item, 'data.visuals.avatarImage.sources.0.url') || this.defaultImageUrl;
                    
                    artists.push({
                        id: item.data.uri || `artist-${Date.now()}`,
                        name: item.data.profile.name || 'Unknown Artist',
                        artist: item.data.profile.name || 'Unknown Artist',
                        image: imageUrl,
                        previewUrl: null,
                        isArtist: true,
                        isPlaying: false,
                        type: 'artist'
                    });
                }
            });
        }

       
        this.results = [...tracks, ...albums, ...artists];
    }

    renderedCallback() {
        
        this.setupAudioEventListeners();
        
        
        this.updateButtonClasses();
    }
    
    setupAudioEventListeners() {
        
        const audioElement = this.template.querySelector('audio');
        if (audioElement && !this.audioElement) {
            this.audioElement = audioElement;
            
           
            audioElement.addEventListener('ended', this.handleAudioEnded.bind(this));
            audioElement.addEventListener('play', () => this.updatePlayingState(true));
            audioElement.addEventListener('pause', () => this.updatePlayingState(false));
            audioElement.addEventListener('error', (e) => this.handleAudioError(e));
            audioElement.addEventListener('loadeddata', () => this.debugInfo += 'Audio loaded\\n');
            audioElement.addEventListener('playing', () => this.debugInfo += 'Audio playing\\n');
        }
    }
    
    updateButtonClasses() {
        
        const buttons = this.template.querySelectorAll('.play-button');
        
        
        if (buttons && buttons.length > 0) {
            buttons.forEach(button => {
                const trackId = button.dataset.id;
                if (trackId) {
                    const track = this.results.find(item => item.id === trackId);
                    if (track && track.isPlaying) {
                        button.classList.add('playing');
                    } else {
                        button.classList.remove('playing');
                    }
                }
            });
        }
    }

    handleTogglePlay(event) {
        const trackId = event.currentTarget.dataset.id;
        if (!trackId) return;  
        
        
        const trackIndex = this.results.findIndex(item => item.id === trackId);
        if (trackIndex === -1) return;
        
        const track = this.results[trackIndex];
        
       
        if (track.isAlbum || track.isArtist) {
            this.showToast('Selection', `You selected "${track.name}"`, 'info');
            return;
        }
        
        
        if (this.currentTrackId === trackId && this.audioElement) {
            if (this.audioElement.paused) {
                this.audioElement.play()
                    .then(() => {
                        this.debugInfo += 'Resumed playback\\n';
                    })
                    .catch(error => {
                        this.debugInfo += `Resume error: ${error.message}\\n`;
                        this.showToast('Playback Error', `Could not resume: ${error.message}`, 'error');
                    });
            } else {
                this.audioElement.pause();
                this.debugInfo += 'Paused playback\\n';
            }
            return;
        }
        
       
        this.isLoading = true;
        this.debugInfo = `Fetching preview for track: ${trackId}\\n`;
        
       
        getTrackPreview({ trackId: track.id })
            .then(data => {
                if (data) {
                    try {
                        const trackData = JSON.parse(data);
                        
                        if (trackData && trackData.tracks && trackData.tracks.length > 0) {
                            const previewUrl = trackData.tracks[0].preview_url;
                            this.debugInfo += `Preview URL found: ${previewUrl ? 'Yes' : 'No'}\\n`;
                            
                            if (previewUrl) {
                                
                                if (this.currentTrackId) {
                                    this.resetCurrentTrack();
                                }
                                
                                this.setupAudioPlayback(previewUrl, track, trackId);
                            } else {
                                this.isLoading = false;
                                this.showToast('No Preview', 'No preview available for this track', 'warning');
                            }
                        } else {
                            this.isLoading = false;
                            this.showToast('No Preview', 'No preview available for this track', 'warning');
                        }
                    } catch (error) {
                        this.isLoading = false;
                        console.error('Error parsing track data:', error);
                        this.debugInfo += `Parse error: ${error.message}\\n`;
                        this.showToast('Error', 'Error processing track data', 'error');
                    }
                } else {
                    this.isLoading = false;
                    this.showToast('No Preview', 'No preview available for this track', 'warning');
                }
            })
            .catch(error => {
                this.isLoading = false;
                console.error('Error fetching track preview:', error);
                this.debugInfo += `Fetch error: ${error.message}\\n`;
                this.showToast('Error', 'Error fetching track preview', 'error');
            });
    }
    
    setupAudioPlayback(previewUrl, track, trackId) {
       
        const baseUrl = window.location.origin;
        const proxyPath = '/services/apexrest/spotifyproxy';
        const fullProxyUrl = `${baseUrl}${proxyPath}?url=${encodeURIComponent(previewUrl)}`;
        
        this.debugInfo += `Full proxy URL: ${fullProxyUrl}\\n`;
        this.audioUrl = fullProxyUrl;
        
       
        this.currentTrackId = trackId;
        this.currentTrackData = {
            ...track,
            originalPreviewUrl: previewUrl
        };
        this.isPlayerVisible = true;
        
        
        setTimeout(() => {
            if (this.audioElement) {
                this.debugInfo += 'Loading audio...\\n';

                
                this.audioElement.load();
                
                this.audioElement.play()
                    .then(() => {
                        this.debugInfo += 'Audio playback started\\n';
                        this.isLoading = false;
                    })
                    .catch(error => {
                        this.isLoading = false;
                        this.debugInfo += `Playback error: ${error.message}\\n`;
                        console.error('Error playing audio:', error);
                        this.showToast('Playback Error', `Could not play audio: ${error.message}`, 'error');
                    });
            } else {
                this.isLoading = false;
                this.debugInfo += 'Audio element not found\\n';
                this.showToast('Error', 'Audio player not found', 'error');
            }
        }, 100);
    }
    
    handleAudioError(event) {
        const errorMessages = {
            1: 'The fetch operation was aborted',
            2: 'Network error occurred',
            3: 'The audio decoding failed',
            4: 'Audio source not supported'
        };
        
        const errorCode = this.audioElement ? this.audioElement.error.code : 'unknown';
        const errorMsg = errorMessages[errorCode] || 'Unknown audio error';
        
        this.debugInfo += `Audio error (${errorCode}): ${errorMsg}\\n`;
        console.error('Audio error:', errorMsg, event);
        this.showToast('Audio Error', errorMsg, 'error');
    }
    
    updatePlayingState(isPlaying) {
        if (this.currentTrackId) {
            const index = this.results.findIndex(item => item.id === this.currentTrackId);
            if (index !== -1) {
                const updatedResults = [...this.results];
                updatedResults[index] = {...this.results[index], isPlaying: isPlaying};
                this.results = updatedResults;
            }
            
            if (this.currentTrackData) {
                this.currentTrackData = {
                    ...this.currentTrackData,
                    isPlaying: isPlaying
                };
            }
            
            
            this.updateButtonClasses();
        }
    }
    
    resetCurrentTrack() {
        
        if (this.currentTrackId) {
            const index = this.results.findIndex(item => item.id === this.currentTrackId);
            if (index !== -1) {
                const updatedResults = [...this.results];
                updatedResults[index] = {...this.results[index], isPlaying: false};
                this.results = updatedResults;
            }
        }
    }
    
    handleAudioEnded() {
        this.debugInfo += 'Audio ended\\n';
        this.resetCurrentTrack();
        this.currentTrackId = null;
        this.currentTrackData = null;
        this.isPlayerVisible = false;
        this.audioUrl = null;
    }
    
    
    showToast(title, message, variant = 'info') {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
            })
        );
    }

    disconnectedCallback() {
       
        if (this.audioElement) {
            this.audioElement.removeEventListener('ended', this.handleAudioEnded);
            this.audioElement.removeEventListener('play', this.updatePlayingState);
            this.audioElement.removeEventListener('pause', this.updatePlayingState);
            this.audioElement.removeEventListener('error', this.handleAudioError);
            this.audioElement.removeEventListener('loadeddata', () => {});
            this.audioElement.removeEventListener('playing', () => {});
        }
    }
}