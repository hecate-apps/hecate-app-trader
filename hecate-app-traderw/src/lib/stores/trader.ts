import { writable, derived } from 'svelte/store';

interface HealthData {
	ok: boolean;
	app: string;
	version: string;
	node: string;
}

export const health = writable<HealthData | null>(null);
export const connectionStatus = writable<'disconnected' | 'connecting' | 'connected'>('disconnected');

let pollInterval: ReturnType<typeof setInterval> | null = null;

async function checkHealth() {
	connectionStatus.set('connecting');
	try {
		const res = await fetch('/health');
		if (res.ok) {
			const data = await res.json();
			health.set(data);
			connectionStatus.set('connected');
		} else {
			connectionStatus.set('disconnected');
		}
	} catch {
		connectionStatus.set('disconnected');
	}
}

export function startPolling() {
	checkHealth();
	pollInterval = setInterval(checkHealth, 10000);
}

export function stopPolling() {
	if (pollInterval) {
		clearInterval(pollInterval);
		pollInterval = null;
	}
}
