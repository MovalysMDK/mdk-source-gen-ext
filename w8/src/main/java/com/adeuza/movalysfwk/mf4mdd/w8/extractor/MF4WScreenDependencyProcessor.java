/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.w8.extractor;

import java.util.ArrayList;
import java.util.List;
import java.util.Map.Entry;

import org.apache.commons.lang3.StringUtils;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.a2a.adjava.uml.UmlDictionary;
import com.a2a.adjava.uml.UmlUsage;
import com.a2a.adjava.uml2xmodele.ui.screens.PanelAggregation;
import com.a2a.adjava.uml2xmodele.ui.screens.ScreenContext;
import com.a2a.adjava.uml2xmodele.ui.screens.ScreenDependencyProcessor;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.MVisualField;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelTypeConfiguration;
import com.adeuza.movalysfwk.mf4mdd.w8.xmodele.MF4WPage;

public class MF4WScreenDependencyProcessor extends ScreenDependencyProcessor {
	
	/**
	 * Singleton instance
	 */
	private static MF4WScreenDependencyProcessor instance = new MF4WScreenDependencyProcessor();

	/**
	 * Return singleton instance
	 * @return singleton instance
	 */
	public static MF4WScreenDependencyProcessor getInstance() {
		return instance;
	}

	/**
	 * {@inheritDoc}
	 * @param p_oScreen
	 */
	@Override
	protected void setLayoutForSinglePageScreen(MScreen p_oScreen) {
		// Do not put the panel layout inside the screen layout
	}
}

