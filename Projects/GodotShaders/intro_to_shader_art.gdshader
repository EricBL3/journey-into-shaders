shader_type canvas_item;

vec3 og_palette(float t, vec3 a, vec3 b, vec3 c, vec3 d)
{
	return a + b * cos(6.28318 * (c * t + d));
}

vec3 palette(float t)
{
	vec3 a = vec3(1.118, 0.948, 0.558);
	vec3 b = vec3(-1.306, 0.533, 0.370);
	vec3 c = vec3(0.608, 0.608, 0.863);
	vec3 d = vec3(-0.273, -1.273, -0.443);
	
	return og_palette(t, a, b, c, d);
}

void fragment() {
	// Place fragment code here.
	vec2 uv = vec2(UV.x, 1.0 - UV.y) * 2.0 - 1.0;
	vec2 uv0 = uv;
	vec3 finalColor = vec3(0.0);
	for(float i = 0.0; i < 4.0; i++)
	{
		uv = fract(uv * 1.5) - 0.5;
		float d = length(uv) * exp(-length(uv0));

		vec3 col = palette(length(uv0) + i*0.4 + TIME*0.4);

		d = sin(d * 8.0 + TIME) / 8.0;
		d = abs(d);

		d = pow(0.01 / d, 1.8);

		finalColor += col * d;
	}
	COLOR = vec4(finalColor, 1.0);
}
