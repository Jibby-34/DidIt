// Example Cloudflare Worker for AI-powered streak generation
// Deploy this to Cloudflare Workers and update the URL in app_constants.dart

export default {
  async fetch(request, env) {
    // Handle CORS preflight
    if (request.method === 'OPTIONS') {
      return new Response(null, {
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'POST, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type',
        },
      });
    }

    if (request.method !== 'POST') {
      return new Response('Method not allowed', { status: 405 });
    }

    try {
      const body = await request.json();
      const { type, streakName, tone } = body;

      if (type !== 'streak_setup' || !streakName) {
        return new Response(
          JSON.stringify({ error: 'Invalid request' }),
          { 
            status: 400,
            headers: { 'Content-Type': 'application/json' }
          }
        );
      }

      // Call Google Gemini API
      // You'll need to set up GEMINI_API_KEY in your Cloudflare Worker environment variables
      const geminiResponse = await fetch(
        `https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=${env.GEMINI_API_KEY}`,
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            contents: [{
              parts: [{
                text: `You are a motivational coach helping someone build a daily habit streak.

Streak name: "${streakName}"
Tone: ${tone}

Respond ONLY with valid JSON in this exact format (no markdown, no explanation):
{
  "emoji": "single emoji that represents this streak",
  "description": "one motivating sentence about this streak (max 100 chars)",
  "steps": [
    "step 1 (actionable, specific, max 60 chars)",
    "step 2 (actionable, specific, max 60 chars)",
    "step 3 (actionable, specific, max 60 chars)"
  ]
}

Make it energetic and motivating. Use emojis that fit the activity, but default to ⚡ if unsure.`
              }]
            }],
            generationConfig: {
              temperature: 0.9,
              topK: 1,
              topP: 1,
              maxOutputTokens: 2048,
            },
          }),
        }
      );

      if (!geminiResponse.ok) {
        throw new Error('Gemini API error');
      }

      const geminiData = await geminiResponse.json();
      const generatedText = geminiData.candidates[0].content.parts[0].text;

      // Parse the JSON response from Gemini
      // Remove any markdown code blocks if present
      const cleanedText = generatedText
        .replace(/```json\n?/g, '')
        .replace(/```\n?/g, '')
        .trim();

      const result = JSON.parse(cleanedText);

      // Validate the response
      if (!result.emoji || !result.description || !Array.isArray(result.steps)) {
        throw new Error('Invalid response format from AI');
      }

      return new Response(
        JSON.stringify(result),
        {
          status: 200,
          headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
          },
        }
      );

    } catch (error) {
      console.error('Worker error:', error);
      
      // Return fallback response
      return new Response(
        JSON.stringify({
          emoji: '⚡',
          description: 'Build momentum, one day at a time.',
          steps: [
            'Start small and stay consistent',
            'Track your progress daily',
            'Celebrate every milestone',
          ],
        }),
        {
          status: 200,
          headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
          },
        }
      );
    }
  },
};

