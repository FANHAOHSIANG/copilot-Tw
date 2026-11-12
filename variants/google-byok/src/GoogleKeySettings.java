package com.navipilot.google;
import android.app.*;
import android.content.*;
import android.content.pm.*;
import android.os.Build;
import android.security.keystore.*;
import android.text.InputType;
import android.view.View;
import android.widget.*;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.security.*;
import javax.crypto.*;
import javax.crypto.spec.GCMParameterSpec;
import com.google.android.libraries.navigation.NavigationApi;

/** Optional Navigation SDK 7.6+ module. No dependency from offline camera alerts. */
public final class GoogleKeySettings {
 private static final String ALIAS="copilot.google.key.v1";
 private static final GoogleKeyGate gate=new GoogleKeyGate();
 private static SecretKey secret() throws Exception {
  KeyStore store=KeyStore.getInstance("AndroidKeyStore");store.load(null);
  if(store.containsAlias(ALIAS))return (SecretKey)store.getKey(ALIAS,null);
  KeyGenerator g=KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES,"AndroidKeyStore");
  g.init(new KeyGenParameterSpec.Builder(ALIAS,KeyProperties.PURPOSE_ENCRYPT|KeyProperties.PURPOSE_DECRYPT)
   .setBlockModes(KeyProperties.BLOCK_MODE_GCM).setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE).build());
  return g.generateKey();
 }
 private static File file(Context c){return new File(c.getNoBackupFilesDir(),"google-key-v1.bin");}
 private static String read(Context c)throws Exception {
  File f=file(c);if(!f.exists())return "";
  if(f.length()>2048)throw new IOException("invalid credential store");
  try(DataInputStream in=new DataInputStream(new FileInputStream(f))){
   int n=in.readUnsignedByte();if(n!=12)throw new IOException("invalid credential store");
   byte[] iv=new byte[n];in.readFully(iv);byte[] ciphertext=new byte[(int)f.length()-n-1];in.readFully(ciphertext);
   Cipher cipher=Cipher.getInstance("AES/GCM/NoPadding");cipher.init(Cipher.DECRYPT_MODE,secret(),new GCMParameterSpec(128,iv));
   return new String(cipher.doFinal(ciphertext),StandardCharsets.UTF_8);
  }
 }
 private static void write(Context c,String key)throws Exception {
  if(key.length()>256||key.matches(".*\\s+.*"))throw new IllegalArgumentException("invalid key format");
  Cipher cipher=Cipher.getInstance("AES/GCM/NoPadding");cipher.init(Cipher.ENCRYPT_MODE,secret());
  byte[] encrypted=cipher.doFinal(key.getBytes(StandardCharsets.UTF_8));File target=file(c),temp=new File(target+".tmp");
  try(FileOutputStream stream=new FileOutputStream(temp);DataOutputStream out=new DataOutputStream(stream)){
   out.writeByte(cipher.getIV().length);out.write(cipher.getIV());out.write(encrypted);out.flush();stream.getFD().sync();
  }
  if(!temp.renameTo(target)){temp.delete();throw new IOException("credential save failed");}
 }
 /** Call before inflating a Google map or obtaining Navigator. DISABLED means use offline mode. */
 public static synchronized GoogleKeyGate.Result initialize(Context context)throws Exception {
  return gate.initialize(read(context),new GoogleKeyGate.Installer(){public void install(String key){NavigationApi.setApiKey(key);}});
 }
 public static String androidRestriction(Context c)throws Exception {
  PackageInfo info=c.getPackageManager().getPackageInfo(c.getPackageName(),Build.VERSION.SDK_INT>=28?PackageManager.GET_SIGNING_CERTIFICATES:PackageManager.GET_SIGNATURES);
  android.content.pm.Signature[] certificates=Build.VERSION.SDK_INT>=28?info.signingInfo.getApkContentsSigners():info.signatures;
  StringBuilder out=new StringBuilder(c.getPackageName());
  for(android.content.pm.Signature signature:certificates){byte[] digest=MessageDigest.getInstance("SHA-1").digest(signature.toByteArray());out.append("\nSHA-1: ");for(int i=0;i<digest.length;i++){if(i>0)out.append(':');out.append(String.format(java.util.Locale.US,"%02X",digest[i]&255));}}
  return out.toString();
 }
 public static void show(final Activity activity){
  final EditText input=new EditText(activity);input.setSingleLine(true);input.setSaveEnabled(false);
  input.setInputType(InputType.TYPE_CLASS_TEXT|InputType.TYPE_TEXT_VARIATION_PASSWORD);
  if(Build.VERSION.SDK_INT>=26)input.setImportantForAutofill(View.IMPORTANT_FOR_AUTOFILL_NO_EXCLUDE_DESCENDANTS);
  input.setHint(file(activity).exists()?"已保存；輸入新金鑰可替換":"貼上自己的 Google API 金鑰");
  String certificate;
  try{certificate=androidRestriction(activity);}catch(Exception e){certificate=activity.getPackageName()+"\n無法讀取簽章指紋";}
  final String restriction=certificate;
  LinearLayout layout=new LinearLayout(activity);layout.setOrientation(LinearLayout.VERTICAL);layout.setPadding(24,16,24,16);
  TextView description=new TextView(activity);description.setText("Google 導航選用功能。請在自己的 Google Cloud 專案啟用 Navigation SDK，設定付款與 API 限制。儲存不代表授權已通過。未填金鑰仍可使用離線測速提醒。\n\n"+certificate);layout.addView(description);layout.addView(input);
  Button copy=new Button(activity);copy.setText("複製套件名稱與 SHA-1");copy.setOnClickListener(new View.OnClickListener(){public void onClick(View v){((ClipboardManager)activity.getSystemService(Context.CLIPBOARD_SERVICE)).setPrimaryClip(ClipData.newPlainText("Android API restriction",restriction));}});layout.addView(copy);
  final AlertDialog dialog=new AlertDialog.Builder(activity).setTitle("我的 Google 導航金鑰").setView(layout).setPositiveButton("儲存",null).setNegativeButton("取消",null).setNeutralButton("清除",null).create();
  dialog.setOnShowListener(new DialogInterface.OnShowListener(){public void onShow(DialogInterface ignored){
   dialog.getButton(AlertDialog.BUTTON_POSITIVE).setOnClickListener(new View.OnClickListener(){public void onClick(View v){
    String value=input.getText().toString().trim();if(value.isEmpty()){input.setError("請貼上金鑰，或取消保留原設定");return;}
    try{write(activity,value);input.getText().clear();Toast.makeText(activity,"已儲存。請關閉並重新開啟 App；導航初始化時才會檢查授權。",Toast.LENGTH_LONG).show();dialog.dismiss();}
    catch(Exception e){input.getText().clear();input.setError("無法儲存；請確認輸入格式與裝置安全儲存狀態");}
   }});
   dialog.getButton(AlertDialog.BUTTON_NEUTRAL).setOnClickListener(new View.OnClickListener(){public void onClick(View v){
    if(file(activity).exists()&&!file(activity).delete()){Toast.makeText(activity,"清除失敗",Toast.LENGTH_SHORT).show();return;}
    input.getText().clear();Toast.makeText(activity,"已清除；重啟 App 後停用 Google 導航。離線提醒不受影響。",Toast.LENGTH_LONG).show();dialog.dismiss();
   }});
  }});dialog.show();
 }
 private GoogleKeySettings(){}
}
