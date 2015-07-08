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
package com.adeuza.movalysfwk.mf4mdd.ios.umlupdater;

import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.languages.ios.extractors.IOSScreenExtractor;
import com.a2a.adjava.messages.MessageHandler;
import com.a2a.adjava.uml.UmlAssociationEnd;
import com.a2a.adjava.uml.UmlClass;
import com.a2a.adjava.uml.UmlModel;
import com.a2a.adjava.uml.UmlStereotype;
import com.a2a.adjava.umlupdater.AbstractUmlUpdater;
import com.adeuza.movalysfwk.mf4mdd.commons.umlupdater.ControlCapitalizationNameClasses;

public class PanelStereotypeControl extends AbstractUmlUpdater {


	/**
	 * Class Loger
	 */
	private static final Logger log = LoggerFactory.getLogger(PanelStereotypeControl.class);

	private static final String[] forbiddenPanellistStereotypes = new String[]{"Mm_panellist", "Mm_panellist2", "Mm_panellist3"};

	public static final String MM_OLD_IOS_SINGLE_CONTROLLER = "Mm_iosSingleController";



	@Override
	public void execute(UmlModel p_oUmlModele, Map<String, ?> p_oGlobalSession)
			throws Exception {

		log.debug("> Execute control of panel stereotypes.");

		Collection<UmlClass> oAllClasses = p_oUmlModele.getDictionnary().getClassesByStereotype(new UmlStereotype(IOSScreenExtractor.MM_IOS_SINGLE_CONTROLLER, ""));
		for (UmlClass oClass : oAllClasses)
		{
			List<UmlAssociationEnd> oAssociations = oClass.getAssociations();
			for(UmlAssociationEnd oAssociationEnd : oAssociations) {
				if(oAssociationEnd.getRefClass().hasAnyStereotype(Arrays.asList(forbiddenPanellistStereotypes))) {
					MessageHandler.getInstance().addError("The panel {} in the screen {} that has stereotype {} cannot have stereotypes [{}]",
							oAssociationEnd.getRefClass().getName(), oClass.getName(), IOSScreenExtractor.MM_IOS_SINGLE_CONTROLLER, Arrays.asList(forbiddenPanellistStereotypes));

				}
			}
		}
		oAllClasses = p_oUmlModele.getDictionnary().getClassesByStereotype(new UmlStereotype(PanelStereotypeControl.MM_OLD_IOS_SINGLE_CONTROLLER, ""));
		if(oAllClasses != null && oAllClasses.size() > 0 ) {
			for (UmlClass oClass : oAllClasses) {
				MessageHandler.getInstance().addError("The stereotype {} use on the class {} is deprecated. You should replace it with {}", PanelStereotypeControl.MM_OLD_IOS_SINGLE_CONTROLLER, oClass.getName(),
						IOSScreenExtractor.MM_IOS_SINGLE_CONTROLLER);
			}
		}

		log.debug("> End of the control.");

	}

}
