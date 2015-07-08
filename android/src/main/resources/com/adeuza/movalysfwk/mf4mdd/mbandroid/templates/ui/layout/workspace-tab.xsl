<?xml version="1.0" encoding="UTF-8"?>
<!--

    Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)

    This file is part of Movalys MDK.
    Movalys MDK is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    Movalys MDK is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU Lesser General Public License for more details.
    You should have received a copy of the GNU Lesser General Public License
    along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" indent="yes"/>

<xsl:template match="workspace-tab-layout">

<RelativeLayout
    android:layout_height="match_parent"
    android:layout_width="match_parent"
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:movalys="http://www.adeuza.com/movalys/mm/android"
    xmlns:mdk="http://schemas.android.com/apk/res-auto"
    android:descendantFocusability="blocksDescendants" >
    
    <xsl:attribute name="android:id">@+id/<xsl:value-of select="layout"/></xsl:attribute>
    
	<android.support.v4.app.FragmentTabHost
		android:id="@android:id/tabhost" 
		android:layout_width="match_parent"	
		android:layout_height="match_parent">
		
		<LinearLayout 
	        android:orientation="vertical"
	        android:layout_width="match_parent"
	        android:layout_height="match_parent"
	        android:padding="5dp">
			<TabWidget 
				android:id="@android:id/tabs"
				android:layout_width="match_parent" 
				android:layout_height="wrap_content"
				style="?attr/tab_theme"/>
				
				<FrameLayout 
					android:id="@android:id/tabcontent"
					android:layout_width="match_parent" 
					android:layout_height="0dp"
					android:layout_weight="0"/>
					
				<FrameLayout 
					android:id="@+id/realcontent"
					android:layout_width="match_parent" 
					android:layout_height="0dp"
					android:layout_weight="1"/>
					
		</LinearLayout>
		
	</android.support.v4.app.FragmentTabHost>
	
</RelativeLayout>

	</xsl:template>

</xsl:stylesheet>