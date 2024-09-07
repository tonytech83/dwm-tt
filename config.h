/* See LICENSE file for copyright and license details. */

#include <X11/XF86keysym.h>

/* appearance */
static const unsigned int borderpx  		= 1;        /* border pixel of windows */
static const unsigned int snap      		= 32;       /* snap pixel */
static const unsigned int systraypinning 	= 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayonleft 	= 0;    /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing 	= 2;   /* systray spacing */
static const int systraypinningfailfirst 	= 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray        		= 1;        /* 0 means no systray */
static const int showbar            		= 1;        /* 0 means no bar */
static const int topbar             		= 1;        /* 0 means bottom bar */
#define ICONSIZE 				(bh -4)  /* icon size */
#define ICONSPACING 				5 /* space between icon and title */
static const char *fonts[]          		= { "monospace:style:bold:size:13" };
static const char norm_border_col[]   		= "#3B4252";
static const char norm_bg_col[]       		= "#2E3440";
static const char norm_fg_col[]       		= "#D8DEE9";
static const char sel_border_col[]    		= "#434C5E";
static const char sel_bg_col[]        		= "#434C5E";
static const char sel_fg_col[]        		= "#ECEFF4";
static const char *colors[][3]      		= {
	/*               fg         bg         border   */
	[SchemeNorm] = { norm_fg_col, norm_bg_col, norm_border_col },
	[SchemeSel]  = { sel_fg_col, sel_bg_col, sel_border_col  },
};

/* scratchpads */
typedef struct {
	const char *name;
	const void *cmd;
} Sp;
const char *spcmd1[] = {"keepassxc", NULL };
const char *spcmd2[] = {"rofi-wifi-menu.sh", NULL };
static Sp scratchpads[] = {
	/* name          		cmd  */
	{"keepassxc",   		spcmd1},
	{"rofi-wifi-menu.sh", 	spcmd2},
};

/* cool autostart */
static const char *const autostart[] = {
	"xset", "s", "off", NULL,
	"xset", "s", "noblank", NULL,
	"xset", "-dpms", NULL,
	"dbus-update-activation-environment", "--systemd", "--all", NULL,
	"flameshot", NULL,
	"picom", "-b", NULL,
	"nm-applet", NULL,
	"conky", "-c", "~/.config/conky/dwm/nord.conkyrc", NULL,
	"sh", "-c", "feh --randomize --bg-fill ~/Pictures/wall/*", NULL,
	NULL /* terminate */
};

/* tagging */
static const char *tags[] = { "", "", "", "","" };

static const unsigned int ulinepad	= 5;	/* horizontal padding between the underline and tag */
static const unsigned int ulinestroke	= 2;	/* thickness / height of the underline */
static const unsigned int ulinevoffset	= 0;	/* how far above the bottom of the bar the line should appear */
static const int ulineall 		= 0;	/* 1 to show underline on all tags, 0 for just the active ones */

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      		instance    	title       	tags mask   	isfloating  	monitor */
	{ "kitty",		NULL,		NULL,		0,		0,		-1 },
	{ "thorium-browser",    NULL,       	NULL,       	1 << 2,     	0,		-1 },
	{ "thunar",             NULL,     	NULL,       	0,		1,      	-1 },
	{ NULL,       		"keepassxc",	NULL,       	SPTAG(0),   	1,   	    	-1 },
};

/* layout(s) */
static const float mfact        = 0.5;  /* factor of master area size [0.05..0.95] */
static const int nmaster        = 1;    /* number of clients in master area */
static const int resizehints    = 0;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1;    /* 1 will force focus on the fullscreen window */
static const int attachbelow    = 1;    /* 1 means attach after the currently active window */
 

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "",      tile },    /* first entry is default */
	{ "",      NULL },    /* no layout function means floating behavior */
	{ "",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static const char *launchercmd[] = { "rofi", "-show", "drun", NULL };
static const char *termcmd[]  = { "kitty", NULL };

static const Key keys[] = {
	/* modifier                     key        			function        argument */
	{ MODKEY,                       XK_r,      			spawn,          {.v = launchercmd } },
	{ MODKEY,                       XK_x,      			spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_w,      			spawn,          SHCMD ("thorium-browser") },
	{ MODKEY,        	        XK_e,               		spawn,          SHCMD ("thunar") },
	{ MODKEY,                       XK_b,      			togglebar,      {0} },
	{ MODKEY,                       XK_j,      			focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      			focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      			incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      			incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      			setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      			setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, 			zoom,           {0} },
	{ MODKEY,                       XK_Tab,    			view,           {0} },
	{ MODKEY,                       XK_t,      			setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      			setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      			setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  			setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  			togglefloating, {0} },
	{ MODKEY,                       XK_0,      			view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      			tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  			focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, 			focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  			tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, 			tagmon,         {.i = +1 } },
	/* multimedia */
	{ 0,                            XF86XK_AudioLowerVolume,   	spawn,          SHCMD ("amixer sset Master 5%- unmute")},
    	{ 0,                            XF86XK_AudioMute,          	spawn,          SHCMD ("amixer sset Master $(amixer get Master | grep -q '\\[on\\]' && echo 'mute' || echo 'unmute')")},
    	{ 0,                            XF86XK_AudioRaiseVolume,   	spawn,          SHCMD ("amixer sset Master 5%+ unmute")},

	/* scratchpads */
	{ MODKEY,       		XK_y,	   			togglescratch,  {.ui = 0 } },
	{ MODKEY,       		XK_u,	   			togglescratch,  {.ui = 1 } },

	/* shiftview*/
	{ MODKEY,                       XK_Left,   			shiftview,      {.i = -1 } },
	{ MODKEY,                       XK_Right,  			shiftview,      {.i = +1 } },

	TAGKEYS(                        XK_1,                      	0)
	TAGKEYS(                        XK_2,                      	1)
	TAGKEYS(                        XK_3,                      	2)
	TAGKEYS(                        XK_4,                      	3)
	TAGKEYS(                        XK_5,                      	4)
	TAGKEYS(                        XK_6,                      	5)
	TAGKEYS(                        XK_7,                      	6)
	TAGKEYS(                        XK_8,                      	7)
	TAGKEYS(                        XK_9,                      	8)
	{ MODKEY,                       XK_q,      			killclient,     {0} },
	{ MODKEY|ControlMask,           XK_q,                       	spawn,          SHCMD("powermenu.sh") },
	{ MODKEY|ShiftMask,             XK_q,      			quit,           {0} },
	{ MODKEY|ControlMask|ShiftMask, XK_s,                       	spawn,          SHCMD("systemctl suspend") },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button1,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
