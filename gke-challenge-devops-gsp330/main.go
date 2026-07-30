package main

import (
        "image"
        "image/color"
        "image/draw"
        "image/png"
        "net/http"
)

func main() {
        // מאזין לנתיב /black עבור גרסה v3.0
        http.HandleFunc("/black", blackHandler)
        http.ListenAndServe(":8080", nil)
}

func blackHandler(w http.ResponseWriter, r *http.Request) {
        img := image.NewRGBA(image.Rect(0, 0, 100, 100))
        // צבע שחור: R=0, G=0, B=0
        draw.Draw(img, img.Bounds(), &image.Uniform{color.RGBA{0, 0, 0, 255}}, image.ZP, draw.Src)
        w.Header().Set("Content-Type", "image/png")
        png.Encode(w, img)
}