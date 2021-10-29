# Deformable Quad Shader

正方形のQuadやPlaneのアスペクト比を画像や動画などのアスペクト比に合わせて変形させるシェーダーです。  
VRC_PanoramaやVRC_SyncVideoPlayerに使うと、いい感じになります。

## 内容物

- DeformableQuad_Standard.shader : 影ありのシェーダー
- DeformableQuad_Unlit.shader : 影なしのシェーダー
- DefotmableQuad.cginc : 共通処理を書いたincludeファイル
- Sampleフォルダ以下 : サンプルPrefabなどが入っています。自由に使っていただいて大丈夫です。

## 設定可能項目

- Texture : 表示される画像です。VRC_PanoramaやVRC_SyncVideoPlayerはデフォルトでここに画像が差し込まれます。
- Cull : 表面、裏面を描画するかの設定です。Off→両面、Front→裏面のみ、Back→表面のみ
- ShadeMinValue(Standardのみ) : 影が濃すぎる場合はこれをあげてください

- UseFrame : フレームを使用するときはチェックを入れてください
- Scale : フレームのサイズです
- Thickness : フレームの奥行です
- Frame Texture : フレーム用のテクスチャです
- Frame Color : フレームの色です

## 使い方

縦と横の長さが同じQuadにこのシェーダーを設定したマテリアルをつけてください。  
VRC_PanoramaやSyncVideoPlayerの表示用のオブジェクトにこのシェーダーを適用したマテリアルをつけてください。  
（だいたいVRC_PanoramaコンポーネントやVRC_SyncVideoPlayerコンポーネント、VRC_VideoScreenコンポーネントがついているオブジェクトがそれだと思います。）  
VRC_PanoramaはSampleを同梱しているのでそちらを参照してください。  

画像や動画の縦と横の大きさを見てどちらが大きいかで変形方向を変えています。  
そのため元のQuadより縦または横が変形後に大きくなることはありません。  
- 縦長の画像 -> Quadを横方向(x方向)に変形
- 横長の画像 -> Quadを縦方向(y方向)に変形

## 権利関係

商用利用、改変、再配布など自由にしていただいて大丈夫です。  
しかし、作者を偽るような行為は禁止です。  
使用する際にもクレジット表記は不要です。（あるとうれしいです）

## 免責事項
本製品を使って発生した問題に対してはgatosyocoraは一切の責任を負いません。  

## クレジット

Created by gatosyocora  
Twitter: @gatosyocora  
Booth: https://gatosyocora.booth.pm/  
お問い合わせはBoothかTwitterへ
