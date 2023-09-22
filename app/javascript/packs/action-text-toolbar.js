var Trix = require("trix");
const { lang } = Trix.config;
Trix.config.toolbar = {
  getDefaultHTML() {
    return `\
    <div class="trix-button-row">
        <span class="trix-button-group trix-button-group--text-tools" data-trix-button-group="text-tools">
        <button type="button" class="trix-button" data-trix-attribute="bold" data-trix-key="b" title="${lang.bold}" tabindex="-1">
            <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-bold opacity-75" width="20" height="20" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                <path d="M7 5h6a3.5 3.5 0 0 1 0 7h-6z"></path>
                <path d="M13 12h1a3.5 3.5 0 0 1 0 7h-7v-7"></path>
            </svg>
        </button>
        <button type="button" class="trix-button" data-trix-attribute="italic" data-trix-key="i" title="${lang.italic}" tabindex="-1">
            <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-italic opacity-75" width="20" height="20" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                <line x1="11" y1="5" x2="17" y2="5"></line>
                <line x1="7" y1="19" x2="13" y2="19"></line>
                <line x1="14" y1="5" x2="10" y2="19"></line>
            </svg>
        </button>
        <button type="button" class="trix-button" data-trix-attribute="underline" data-trix-key="u" title="underline" tabindex="-1">
            <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-underline opacity-75" width="20" height="20" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                <path d="M7 5v5a5 5 0 0 0 10 0v-5"></path>
                <path d="M5 19h14"></path>
            </svg>
        </button>
        <button type="button" class="trix-button" data-trix-attribute="strike" title="${lang.strike}" tabindex="-1">
            <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-strikethrough opacity-75" width="20" height="20" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                <line x1="5" y1="12" x2="19" y2="12"></line>
                <path d="M16 6.5a4 2 0 0 0 -4 -1.5h-1a3.5 3.5 0 0 0 0 7h2a3.5 3.5 0 0 1 0 7h-1.5a4 2 0 0 1 -4 -1.5"></path>
            </svg>
        </button>
        <button type="button" class="trix-button" data-trix-attribute="href" data-trix-action="link" data-trix-key="k" title="${lang.link}" tabindex="-1">
            <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-link opacity-75" width="20" height="20" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                <path d="M10 14a3.5 3.5 0 0 0 5 0l4 -4a3.5 3.5 0 0 0 -5 -5l-.5 .5"></path>
                <path d="M14 10a3.5 3.5 0 0 0 -5 0l-4 4a3.5 3.5 0 0 0 5 5l.5 -.5"></path>
            </svg>
        </button>
        </span>
        <span class="trix-button-group trix-button-group--block-tools" data-trix-button-group="block-tools">
            <button type="button" class="trix-button" data-trix-attribute="heading1" title="h1" tabindex="-1">
                <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-h-1 opacity-75" width="20" height="20" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                    <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                    <path d="M19 18v-8l-2 2"></path>
                    <path d="M4 6v12"></path>
                    <path d="M12 6v12"></path>
                    <path d="M11 18h2"></path>
                    <path d="M3 18h2"></path>
                    <path d="M4 12h8"></path>
                    <path d="M3 6h2"></path>
                    <path d="M11 6h2"></path>
                </svg>
            </button>
            <button type="button" class="trix-button" data-trix-attribute="heading2" title="h2" tabindex="-1">
                <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-h-2 opacity-75" width="20" height="20" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                    <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                    <path d="M17 12a2 2 0 1 1 4 0c0 .591 -.417 1.318 -.816 1.858l-3.184 4.143l4 0"></path>
                    <path d="M4 6v12"></path>
                    <path d="M12 6v12"></path>
                    <path d="M11 18h2"></path>
                    <path d="M3 18h2"></path>
                    <path d="M4 12h8"></path>
                    <path d="M3 6h2"></path>
                    <path d="M11 6h2"></path>
                </svg>
            </button>
            <button type="button" class="trix-button" data-trix-attribute="heading3" title="h3" tabindex="-1">
                <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-h-3 opacity-75" width="20" height="20" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                    <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                    <path d="M19 14a2 2 0 1 0 -2 -2"></path>
                    <path d="M17 16a2 2 0 1 0 2 -2"></path>
                    <path d="M4 6v12"></path>
                    <path d="M12 6v12"></path>
                    <path d="M11 18h2"></path>
                    <path d="M3 18h2"></path>
                    <path d="M4 12h8"></path>
                    <path d="M3 6h2"></path>
                    <path d="M11 6h2"></path>
                </svg>
            </button>
            <button type="button" class="trix-button" data-trix-attribute="heading4" title="h4" tabindex="-1">
                <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-h-4 opacity-75" width="20" height="20" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                    <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                    <path d="M20 18v-8l-4 6h5"></path>
                    <path d="M4 6v12"></path>
                    <path d="M12 6v12"></path>
                    <path d="M11 18h2"></path>
                    <path d="M3 18h2"></path>
                    <path d="M4 12h8"></path>
                    <path d="M3 6h2"></path>
                    <path d="M11 6h2"></path>
                </svg>
            </button>
            <button type="button" class="trix-button" data-trix-attribute="heading5" title="h5" tabindex="-1">
                <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-h-5 opacity-75" width="20" height="20" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                    <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                    <path d="M17 18h2a2 2 0 1 0 0 -4h-2v-4h4"></path>
                    <path d="M4 6v12"></path>
                    <path d="M12 6v12"></path>
                    <path d="M11 18h2"></path>
                    <path d="M3 18h2"></path>
                    <path d="M4 12h8"></path>
                    <path d="M3 6h2"></path>
                    <path d="M11 6h2"></path>
                </svg>
            </button>
            <button type="button" class="trix-button" data-trix-attribute="heading6" title="h6" tabindex="-1">
                <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-h-6 opacity-75" width="20" height="20" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                    <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                    <circle transform="rotate(180 19 16)" cx="19" cy="16" r="2"></circle>
                    <path d="M21 12a2 2 0 1 0 -4 0v4"></path>
                    <path d="M4 6v12"></path>
                    <path d="M12 6v12"></path>
                    <path d="M11 18h2"></path>
                    <path d="M3 18h2"></path>
                    <path d="M4 12h8"></path>
                    <path d="M3 6h2"></path>
                    <path d="M11 6h2"></path>
                </svg>
            </button>
            <button type="button" class="trix-button" data-trix-attribute="quote" title="${lang.quote}" tabindex="-1">
                <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-blockquote opacity-75" width="20" height="20" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                    <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                    <path d="M6 15h15"></path>
                    <path d="M21 19h-15"></path>
                    <path d="M15 11h6"></path>
                    <path d="M21 7h-6"></path>
                    <path d="M9 9h1a1 1 0 1 1 -1 1v-2.5a2 2 0 0 1 2 -2"></path>
                    <path d="M3 9h1a1 1 0 1 1 -1 1v-2.5a2 2 0 0 1 2 -2"></path>
                </svg>
            </button>
            <button type="button" class="trix-button" data-trix-attribute="code" title="${lang.code}" tabindex="-1">
                <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-code opacity-75" width="20" height="20" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                    <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                    <polyline points="7 8 3 12 7 16"></polyline>
                    <polyline points="17 8 21 12 17 16"></polyline>
                    <line x1="14" y1="4" x2="10" y2="20"></line>
                </svg>
            </button>
            <button type="button" class="trix-button" data-trix-attribute="bullet" title="${lang.bullets}" tabindex="-1">
                <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-list opacity-75" width="20" height="20" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                    <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                    <line x1="9" y1="6" x2="20" y2="6"></line>
                    <line x1="9" y1="12" x2="20" y2="12"></line>
                    <line x1="9" y1="18" x2="20" y2="18"></line>
                    <line x1="5" y1="6" x2="5" y2="6.01"></line>
                    <line x1="5" y1="12" x2="5" y2="12.01"></line>
                    <line x1="5" y1="18" x2="5" y2="18.01"></line>
                </svg>
            </button>
            <button type="button" class="trix-button" data-trix-attribute="number" title="${lang.numbers}" tabindex="-1">
                <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-list-numbers opacity-75" width="20" height="20" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                    <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                    <path d="M11 6h9"></path>
                    <path d="M11 12h9"></path>
                    <path d="M12 18h8"></path>
                    <path d="M4 16a2 2 0 1 1 4 0c0 .591 -.5 1 -1 1.5l-3 2.5h4"></path>
                    <path d="M6 10v-6l-2 2"></path>
                </svg>
            </button>
            <button type="button" class="trix-button" data-trix-action="decreaseNestingLevel" title="${lang.outdent}" tabindex="-1">
                <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-indent-decrease opacity-75" width="20" height="20" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                    <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                    <line x1="20" y1="6" x2="13" y2="6"></line>
                    <line x1="20" y1="12" x2="11" y2="12"></line>
                    <line x1="20" y1="18" x2="13" y2="18"></line>
                    <path d="M8 8l-4 4l4 4"></path>
                </svg>
            </button>
            <button type="button" class="trix-button" data-trix-action="increaseNestingLevel" title="${lang.indent}" tabindex="-1">
                <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-indent-increase opacity-75" width="20" height="20" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                    <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                    <line x1="20" y1="6" x2="9" y2="6"></line>
                    <line x1="20" y1="12" x2="13" y2="12"></line>
                    <line x1="20" y1="18" x2="9" y2="18"></line>
                    <path d="M4 8l4 4l-4 4"></path>
                </svg>
            </button>
        </span>
        <span class="trix-button-group trix-button-group--file-tools" data-trix-button-group="file-tools">
        <button type="button" class="trix-button trix-button--icon trix-button--icon-attach" data-trix-action="attachFiles" title="${lang.attachFiles}" tabindex="-1">${lang.attachFiles}</button>
        </span>
        <span class="trix-button-group-spacer"></span>
        <span class="trix-button-group trix-button-group--history-tools" data-trix-button-group="history-tools">
            <button type="button" class="trix-button" data-trix-action="undo" data-trix-key="z" title="${lang.undo}" tabindex="-1">
                <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-arrow-back-up opacity-75" width="20" height="20" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                    <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                    <path d="M9 13l-4 -4l4 -4m-4 4h11a4 4 0 0 1 0 8h-1"></path>
                </svg>
            </button>
            <button type="button" class="trix-button" data-trix-action="redo" data-trix-key="shift+z" title="${lang.redo}" tabindex="-1">
                <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-arrow-forward-up opacity-75" width="20" height="20" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                    <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                    <path d="M15 13l4 -4l-4 -4m4 4h-11a4 4 0 0 0 0 8h1"></path>
                </svg>
            </button>
        </span>
    </div>
    <div class="trix-dialogs" data-trix-dialogs>
        <div class="trix-dialog trix-dialog--link" data-trix-dialog="href" data-trix-dialog-attribute="href">
        <div class="trix-dialog__link-fields">
            <input type="url" name="href" class="trix-input trix-input--dialog" placeholder="${lang.urlPlaceholder}" aria-label="${lang.url}" required data-trix-input>
            <div class="trix-button-group">
            <input type="button" class="trix-button trix-button--dialog" value="${lang.link}" data-trix-method="setAttribute">
            <input type="button" class="trix-button trix-button--dialog" value="${lang.unlink}" data-trix-method="removeAttribute">
            </div>
        </div>
        </div>
    </div>\
  `;
  },
};


Trix.config.textAttributes.underline = {
    style: { textDecoration: "underline" },
    parser: function (element) {
        return element.style.textDecoration === "underline";
    },
    inheritable: true,
}

Trix.config.blockAttributes.heading2 = {
    tagName: 'h2'
}

Trix.config.blockAttributes.heading3 = {
    tagName: 'h3'
}

Trix.config.blockAttributes.heading4 = {
    tagName: 'h4'
}

Trix.config.blockAttributes.heading5 = {
    tagName: 'h5'
}

Trix.config.blockAttributes.heading6 = {
    tagName: 'h6'
}

Trix.config.blockAttributes.quote = {
    tagName: 'pre',
}