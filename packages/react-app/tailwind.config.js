/** @type {import('tailwindcss').Config} */ 
module.exports = {

	content: [
		"./src/**/*.{js,ts,jsx,tsx}",
		"./components/**/*.{js,ts,jsx,tsx}",
	],
	enabled: true,
	darkMode: "class",

	variants: {
	  fill: ['hover', 'focus'], 
	},
  
	theme: {
		extend: {
			backgroundImage: {
				'gradient-radial': 'radial-gradient(var(--gradient-color-stops))',
			  },

			colors: {
				display: ["group-hover"],
				youth: {
				  900: "#535209",
				  800: "#9a9811",
				  600: "#cfcc16",
				  700: "#ebe849",
				  500: "#F1EF7E",//Main
				  400: "#f5f3a1",
				  300: "#d6d49a",
				  200: "#c5c5aa",
				  100: "#babab5",
			  },

				biker: {
					900: "#2d4f0f",
					800: "#498118",
					700: "#75C31D",
					600: "#97e056",
					500: "#ABE677",//Main
					400: "#abec71",
					300: "#abe07d",
					200: "#adcd90",
					100: "#aebba2",
				},

				sholar: {
					900: "#030512",
					800: "#081034",
					700: "#0e1a55",
					600: "#132477",
					500: "#162988",//Main
					400: "#1b33aa",
					300: "#2443dc",
					200: "#798ce9",
					100: "#bcc6f4",
				},

        Tourist: {
				  900: "#371f04",
				  800: "#6e3e08",
				  700: "#a55d0c",
				  600: "#c9710f",
				  500: "#EF8F24",//Main
				  600: "#f2a249",
				  300: "#f7c792",
				  200: "#fadab6",
				  100: "#fcecdb",
				},

			},
			screens: {
				'2xl': '1800px',
				'xl': '1200px',
				'md': '900px',
			  },

			borderRadius: {
				'xl': '50px',
			},

			fontFamily: {
			
			},
			container: {
				center: true,
			},
		},
	},
	plugins: [
		// ...
	  ],
  };
