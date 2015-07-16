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

<xsl:output method="text" indent="yes" omit-xml-declaration="no"/>

<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/mbandroid/templates/includes/incremental/nongenerated.xsl"/>

<xsl:template match="screen">
<xsl:text>package </xsl:text><xsl:value-of select="package"/>;

import android.support.test.rule.ActivityTestRule;
import android.support.test.runner.AndroidJUnit4;
import android.test.suitebuilder.annotation.LargeTest;

import static android.support.test.espresso.Espresso.onView;
import static android.support.test.espresso.action.ViewActions.click;
import static android.support.test.espresso.action.ViewActions.closeSoftKeyboard;
import static android.support.test.espresso.action.ViewActions.typeText;
import static android.support.test.espresso.action.ViewActions.pressBack;
import static android.support.test.espresso.assertion.ViewAssertions.matches;
import static android.support.test.espresso.matcher.ViewMatchers.withId;
import static android.support.test.espresso.matcher.ViewMatchers.withText;
import static android.support.test.espresso.matcher.ViewMatchers.isDisplayed;

import com.soprasteria.movalysmdk.espresso.action.SpoonScreenshotAction;
import <xsl:value-of select="full-name"/>;
import <xsl:value-of select="master-package"/>.R;
import com.squareup.spoon.Spoon;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.is;
import static org.hamcrest.Matchers.notNullValue;
import static org.hamcrest.Matchers.lessThan;

import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;

@RunWith(AndroidJUnit4.class)
@LargeTest
public class <xsl:value-of select="name"/>Test {

    @Rule
    public ActivityTestRule&lt;<xsl:value-of select="name"/>&gt; mActivityRule = new ActivityTestRule&lt;&gt;(<xsl:value-of select="name"/>.class);

    @Test
    public void test() {
   		<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">test</xsl:with-param>
		<xsl:with-param name="defaultSource">
			assertThat(mActivityRule.getActivity(), is(notNullValue()));
			SpoonScreenshotAction.perform("<xsl:value-of select="name"/>");
			<!-- 
			<xsl:apply-templates select="layout/buttons/button[@type='NAVIGATION']"/>
			 -->
		</xsl:with-param>
		</xsl:call-template>
        
    }
}
</xsl:template>

<xsl:template match="button[@type='NAVIGATION']">
	onView(withId(R.id.<xsl:value-of select="@label-id"/>)).perform(click());
    SpoonScreenshotAction.perform("<xsl:value-of select="navigation/target/name"/>");
    pressBack();
</xsl:template>

</xsl:stylesheet>