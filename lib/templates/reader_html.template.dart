const readerHTMLTemplate = '''
<!DOCTYPE html>
<html lang="pt-br">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>A.N.R - Reader</title>

    <style>
      * {
        margin: 0px;
        padding: 0px;
        box-sizing: border-box;
      }

      body {
        color: #fff;
        background-color: #000;
      }

      div,
      img {
        width: 100%;
      }

      p.chapter-title {
        width: 100%;
        padding: 1rem 1.5rem;

        color: #fff;
        text-align: center;

        font-size: 1.25rem;
        font-weight: 500;

        background-color: transparent;
      }

      div.anr-novel {
        padding: 0px 1rem 1rem 1rem;
        border-bottom: 1px solid rgba(255, 255, 255, 0.2);
      }

      @keyframes spin {
        0% {
          transform: rotate(0deg);
        }
        100% {
          transform: rotate(360deg);
        }
      }

      #loading {
        width: 100%;
        height: 100vh;

        top: 0;
        left: 0;
        position: fixed;

        display: flex;
        align-items: center;
        justify-content: center;

        pointer-events: none;
        backdrop-filter: blur(2.5px);
        background-color: rgba(0, 0, 0, 0.1);
      }

      #loading > div {
        width: 48px;
        height: 48px;

        border: 5px solid rgba(63, 81, 181, 0.2);
        border-top: 5px solid rgb(63, 81, 181);
        border-radius: 50%;

        animation: spin 0.8s linear infinite;
        background-color: transparent;
      }
    </style>
  </head>
  <body style="overflow-y: hidden;">
    <div id="app"></div>

    <div id="loading">
      <div></div>
    </div>

    <script>
      class Loading {
        static get loading() {
          return document.querySelector("#loading");
        }

        static show() {
          document.body.style.overflowY = "hidden";
          this.loading.style.display = "flex";
          onLoading.postMessage("show");
        }

        static hide() {
          if (this.loading.style.display === "none") return;

          document.body.style.overflowY = null;
          this.loading.style.display = "none";
          onLoading.postMessage("hide");
        }
      }

      class Chapter {
        static get app() {
          return document.querySelector("#app");
        }

        static continueBy(pg) {
          const content = this.app.firstChild;
          if (!content) return;

          const { height } = content.getBoundingClientRect();

          window.scrollTo({
            top: (height * pg) / 100,
            left: 0,
            behavior: "auto",
          });
        }

        static title(value) {
          const title = document.createElement("p");

          title.classList.add("chapter-title");
          title.innerText = value;

          return title;
        }

        static text(content) {
          const container = document.createElement("div");

          container.classList.add("anr-novel");
          container.innerHTML = content;

          return container;
        }

        static images(sources) {
          let loaded = 0;

          return sources.map((src) => {
            const image = document.createElement("img");
            image.setAttribute("src", src);

            image.onload = ({ target }) => {
              if (target.complete) {
                loaded++;
                target.onload = null;

                if (loaded === sources.length) Loading.hide();
              }
            };

            image.onerror = ({ target }) => {
              loaded++;
              target.onload = null;

              if (loaded === sources.length) Loading.hide();
            };

            return image;
          });
        }

        static insert(data) {
          const { id, index, name, content } = JSON.parse(data);

          const container = document.createElement("div");

          container.setAttribute("data-index", index);
          container.setAttribute("id", id);

          container.append(this.title(name));

          if (Array.isArray(content)) container.append(...this.images(content));
          else container.append(this.text(content));

          let calledNext = false;
          let finished = false;

          function onScroll() {
            const { top, height } = container.getBoundingClientRect();
            if (top > 0) return;

            const position = top * -1;

            if (position >= height && !finished) {
              finished = true;
              onFinished.postMessage(JSON.stringify({ id, index, read: 100 }));
            }

            if (position >= (75 / 100) * height && !calledNext) {
              calledNext = true;
              onNext.postMessage(JSON.stringify({ id, index }));
            }

            if (position <= height && position > 0) {
              const value = JSON.stringify({
                id,
                index,
                read: (position * 100) / height,
              });

              onPosition.postMessage(value);
            }

            if (position >= height * 1.25) {
              window.removeEventListener("scroll", scroll);
              container.remove();
            }
          }

          this.app.appendChild(container);
          window.addEventListener("scroll", onScroll);

          if (!Array.isArray(content)) Loading.hide();
        }

        static finished() {
          this.app.appendChild(this.title("Não há mais capítulos no memento."));
        }
      }
    </script>
  </body>
</html>
''';
